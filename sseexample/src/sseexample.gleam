import gleam/bytes_tree
import gleam/erlang/process
import gleam/http/request as http_request
import gleam/http/response as http_response
import gleam/int
import gleam/list
import gleam/otp/actor
import gleam/otp/static_supervisor as sup
import gleam/otp/supervision
import gleam/string
import gleam/string_tree
import group_registry
import logging
import mist
import repeatedly
import youid/uuid

// ------------------------------------------------------------------
// constants
// ------------------------------------------------------------------
const wisp_port = 4000

// 5 seconds
const trigger_interval = 5000

const group_registry_name = "group_registry"

const registry_topic_heartbeats = "heartbeats"

const repeater_process = "repeater"

// ------------------------------------------------------------------
// html
// ------------------------------------------------------------------
const index_html = "
  <!DOCTYPE html>
  <html lang=\"en\">
    <head><title>basic server sent event</title></head>
    <ul>
    <li><a href=\"/example1\">example1 : event.onmessage(0</a></li>
    <li><a href=\"/example2\">example2 : event.addEventListener()</a></li>
    <li><a href=\"/heartbeat\">heartbeat</a></li>
    </ul>
    <body>
    </body>
  </html>
  "

const example_html_1 = "
  <!DOCTYPE html>
  <html lang=\"en\">
    <head><title>basic server sent event #1</title></head>
    <body>
    <p>Event source /heartbeat</p>
    <p>Listening for onmessage (so no mist.event_name here!)</p>
    <div id='time'></div>
      <script>
        const clock = document.getElementById(\"time\")
        const eventz = new EventSource(\"/heartbeat\")
        eventz.onmessage = (e) => {
          console.log(\"got a message\", e)
          const theTime = new Date(parseInt(e.data))
          clock.innerText = theTime.toLocaleString()
        }
        eventz.onclose = () => {
          clock.innerText = \"Done!\"
        }
        // This is not 'ideal' but there is no way to close the connection from
        // the server :(
        eventz.onerror = (e) => {
          eventz.close()
        }
      </script>
    </body>
  </html>
  "

const example_html_2 = "
  <!DOCTYPE html>
  <html lang=\"en\">
    <head><title>basic server sent event #2</title></head>
    <body>
    <p>Event source /heartbeat</p>
    <p>Listening for custom message (so mist.event_name IS SET here!)</p>
    <div id='time'></div>
      <script>
        const clock = document.getElementById(\"time\")
        const eventz = new EventSource(\"/heartbeat\")
        eventz.addEventListener(\"heartbeat\", (e) => {
          console.log(\"got a message\", e)
          const theTime = new Date(parseInt(e.data))
          clock.innerText = theTime.toLocaleString()
        }
        eventz.onclose = () => {
          clock.innerText = \"Done!\"
        }
        // This is not 'ideal' but there is no way to close the connection from
        // the server :(
        eventz.onerror = (e) => {
          eventz.close()
        }
      </script>
    </body>
  </html>
  "

// ------------------------------------------------------------------
// main
// ------------------------------------------------------------------
pub fn main() -> Nil {
  logging.configure()
  logging.set_level(logging.Debug)

  logging.log(logging.Info, "backend server starting...")
  let _ = start_supervisor()
  process.sleep_forever()
}

// ------------------------------------------------------------------
// Supervisor
// ------------------------------------------------------------------
fn start_supervisor() {
  // ------------------------------------------------------------------
  // global names
  // ------------------------------------------------------------------
  let sse_app_registry_name: process.Name(group_registry.Message(SseMsg)) =
  process.new_name(group_registry_name)
  let repeater_process_name: process.Name(RepeaterMsg) =
  process.new_name(repeater_process)

  // ------------------------------------------------------------------
  // web server
  // ------------------------------------------------------------------
  let index_resp =
  http_response.new(200)
  |> http_response.set_body(mist.Bytes(bytes_tree.from_string(index_html)))

  let example_resp_1 =
  http_response.new(200)
  |> http_response.set_body(mist.Bytes(bytes_tree.from_string(example_html_1)))

  let example_resp_2 =
  http_response.new(200)
  |> http_response.set_body(mist.Bytes(bytes_tree.from_string(example_html_2)))

  let webserver_child_spec =
  fn(req: http_request.Request(mist.Connection)) -> http_response.Response(
  mist.ResponseData,
  ) {
    logging.log(
    logging.Debug,
    "Got a request from: " <> string.inspect(mist.get_client_info(req.body)),
    )
    case http_request.path_segments(req) {
      ["heartbeat"] ->
      mist.server_sent_events(
      request: req,
      initial_response: http_response.new(200),
      init: sse_init(sse_app_registry_name, _),
      loop: sse_loop,
      )
      ["example1"] -> example_resp_1
      ["example2"] -> example_resp_2
      _ -> index_resp
    }
  }
  |> mist.new
  |> mist.bind("localhost")
  |> mist.port(wisp_port)
  |> mist.supervised

  // ------------------------------------------------------------------
  // supervision tree
  // ------------------------------------------------------------------
  // RestForOne so that if the db crashes, we restart all
  // the cron jobs. If the cron jobs crash, no need to
  // restart the db
  sup.new(sup.RestForOne)
  |> sup.add(webserver_child_spec)
  |> sup.add(group_registry.supervised(sse_app_registry_name))
  |> sup.add(supervised_repeater(sse_app_registry_name, repeater_process_name))
  |> sup.start
}

// ------------------------------------------------------------------
// supervised repeater
// ------------------------------------------------------------------
pub type HeartbeatState {
  HeartbeatState(
  count: Int,
  repeater: repeatedly.Repeater(Nil),
  xuid: uuid.Uuid,
  )
}

pub type RepeaterMsg {
  RepeaterTriggerHeartbeat
  RepeaterShutdown
}

fn supervised_repeater(
reg_name: process.Name(group_registry.Message(SseMsg)),
repeater_process_name: process.Name(RepeaterMsg),
) -> supervision.ChildSpecification(process.Subject(RepeaterMsg)) {
  let registry = group_registry.get_registry(reg_name)
  supervision.worker(fn() {
    actor.new_with_initialiser(500, fn(subject) {
      let pid = process.self()
      let _ = process.register(pid, repeater_process_name)
      let _ = group_registry.join(registry, registry_topic_heartbeats, pid)
      let repeater =
      repeatedly.call(trigger_interval, Nil, fn(_state, _i) {
        logging.log(
        logging.Debug,
        "repeater-process-send-repeater-trigger-heartbeat",
        )
        process.send(subject, RepeaterTriggerHeartbeat)
      })
      HeartbeatState(repeater:, count: 0, xuid: uuid.v4())
      |> actor.initialised
      |> actor.returning(subject)
      |> Ok
    })
    |> actor.on_message(fn(state, message) {
      case message {
        RepeaterTriggerHeartbeat -> {
          logging.log(
          logging.Debug,
          "repeater-process-repeater-trigger-heartbeat-received",
          )
          // send a message to each registry member
          group_registry.members(registry, registry_topic_heartbeats)
          |> list.each(fn(member) {
            logging.log(
            logging.Debug,
            "repeater-process-send-member-sse-heartbeat",
            )
            let now = system_time(Millisecond)
            process.send(member, SSEHeartbeat(now))
          })
          actor.continue(HeartbeatState(..state, count: state.count + 1))
        }
        RepeaterShutdown -> {
          logging.log(logging.Error, "repeater-process-repeater-shutdown-received")
          // send a message to each registry member
          group_registry.members(registry, registry_topic_heartbeats)
          |> list.each(fn(member) { process.send(member, SSEShutdown) })
          repeatedly.stop(state.repeater)
          actor.continue(state)
        }
      }
    })
    |> actor.start
  })
}

// ------------------------------------------------------------------
// server side events
// ------------------------------------------------------------------
pub type SseMsg {
  SSEHeartbeat(Int)
  SSEShutdown
}

pub type EventState {
  EventState(count: Int, sse_id: uuid.Uuid, error_count: Int)
}

fn sse_init(
reg_name: process.Name(group_registry.Message(SseMsg)),
subject: process.Subject(SseMsg),
) {
  logging.log(logging.Debug, "sse-init")
  let sse_id = uuid.v4()
  let registry = group_registry.get_registry(reg_name)
  let pid = process.self()
  let group_registry_subject =
  group_registry.join(registry, registry_topic_heartbeats, pid)
  let selector =
  process.new_selector()
  |> process.select(group_registry_subject)
  logging.log(logging.Debug, "sse-init-configure-selector")
  actor.initialised(EventState(count: 0, sse_id:, error_count: 0))
  |> actor.returning(subject)
  |> actor.selecting(selector)
  |> Ok
}

fn sse_loop(
state: EventState,
message: SseMsg,
conn: mist.SSEConnection,
) -> actor.Next(EventState, SseMsg) {
  case message {
    SSEHeartbeat(value) -> {
      logging.log(logging.Debug, "sse-loop-sse-heartbeat-message-received")
      // ------------------------------------------------------------------
      // notes regarding mist server sent events
      //
      // 1. mist.event_name == SSEEvent.name
      //
      // https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#listening_for_message_events
      //
      // '''Messages sent from the server that don't have an event field are received as message events. To receive message events, attach a handler for the message event:'''
      //
      // in your html script tag, this handler looks like:
      //
      // ```evtSource.onmessage = (event) => {
      //}```
      //
      // 2. if, however, you are setting `mist.event_name`, then you need a
      // custom event handler as described here:
      //
      // https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#listening_for_custom_events
      //
      //
      // so in your html script tag, the handler looks like:
      //
      //'''evtSource.addEventListener("ping", (event) => {
      //});'''
      //
      // ------------------------------------------------------------------

      // EXAMPLE 1
      // ------------------------------------------------------------------
      // this event send will only succeed for /index1 b/c that html snippet
      // is listening for a regular message via `onmessage`
      // ------------------------------------------------------------------
      let event =
      mist.event(string_tree.from_string(int.to_string(value)))
      |> mist.event_id(state.count |> int.to_string)
      case mist.send_event(conn, event) {
        Ok(_) -> {
          logging.log(
          logging.Debug,
          "sse-loop-sse-heartbeat-message-mist-send-ok",
          )
          actor.continue(EventState(..state, count: state.count + 1))
        }
        Error(_) -> {
          logging.log(
          logging.Error,
          "sse-loop-sse-heartbeat-message-mist-send-error",
          )
          actor.continue(EventState(..state, count: state.error_count + 1))
        }
      }
      // EXAMPLE 2
      // ------------------------------------------------------------------
      // this event send will only succeed for /index2 b/c that html snippet
      // is listening for a custom event via `addEventListener`
      // ------------------------------------------------------------------
      let event =
      mist.event(string_tree.from_string(int.to_string(value)))
      |> mist.event_id(state.count |> int.to_string)
      |> mist.event_name("heartbeat")
      case mist.send_event(conn, event) {
        Ok(_) -> {
          logging.log(
          logging.Debug,
          "sse-loop-sse-heartbeat-message-mist-send-ok",
          )
          actor.continue(EventState(..state, count: state.count + 1))
        }
        Error(_) -> {
          logging.log(
          logging.Error,
          "sse-loop-sse-heartbeat-message-mist-send-error",
          )
          actor.continue(EventState(..state, count: state.error_count + 1))
        }
      }
    }
    SSEShutdown -> {
      logging.log(
      logging.Error,
      "sse-loop-sse-shutdown-message-mist-send-error",
      )
      actor.stop()
    }
  }
}


// ------------------------------------------------------------------
// system time
// ------------------------------------------------------------------
type Unit {
  Millisecond
}

@external(erlang, "erlang", "system_time")
fn system_time(unit: Unit) -> Int
