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
  let app_registry = process.new_name(group_registry_name)

  // ------------------------------------------------------------------
  // web server
  // ------------------------------------------------------------------
  let webserver_child_spec =
    fn(req: http_request.Request(mist.Connection)) -> http_response.Response(
      mist.ResponseData,
    ) {
      logging.log(
        logging.Debug,
        "Got a request from: " <> string.inspect(mist.get_client_info(req.body)),
      )
      case http_request.path_segments(req) {
        _ ->
          mist.server_sent_events(
            request: req,
            initial_response: http_response.new(200),
            init: sse_init(app_registry, _),
            loop: sse_loop,
          )
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
  |> sup.add(group_registry.supervised(app_registry))
  |> sup.add(supervised_repeater(app_registry))
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

pub type RegistryMsg {
  RepeaterTriggerHeartbeat
  RepeaterShutdown
  SSEHeartbeat
}

fn supervised_repeater(
  reg_name: process.Name(group_registry.Message(RegistryMsg)),
) -> supervision.ChildSpecification(process.Subject(RegistryMsg)) {
  let registry = group_registry.get_registry(reg_name)
  supervision.worker(fn() {
    actor.new_with_initialiser(500, fn(subject) {
      let pid = process.self()
      let group_reg =
        group_registry.join(registry, registry_topic_heartbeats, pid)
      let repeater =
        repeatedly.call(trigger_interval, Nil, fn(_state, _i) {
          logging.log(logging.Debug, "repeater-process-send-trigger-heartbeat-message")
          process.send(group_reg, RepeaterTriggerHeartbeat)
        })
      let selector =
        process.new_selector()
        |> process.select(group_reg)
      HeartbeatState(repeater:, count: 0, xuid: uuid.v4())
      |> actor.initialised
      |> actor.returning(subject)
      |> actor.selecting(selector)
      |> Ok
    })
    |> actor.on_message(fn(state, message) {
      case message {
        RepeaterTriggerHeartbeat -> {
          logging.log(logging.Debug, "repeater-trigger-heartbeat-message-received")
          // send a message to each registry member
          group_registry.members(registry, registry_topic_heartbeats)
          |> list.each(fn(member) {
            // TODO: why cannot we send other types, like SseMsg, to the contained processes?
            // TODO: process.send is limited to just RegistryMsg, what part of the method
            // TODO: signature is limiting this?
            // process.send(member, HeartbeatMessage(tag: "heartbeat", xuid: state.xuid))
            logging.log(logging.Debug, "repeater-process-send-member-sse-heartbeat")
            process.send(member, SSEHeartbeat)
          })
          actor.continue(HeartbeatState(..state, count: state.count + 1))
        }
        RepeaterShutdown -> {
          logging.log(logging.Error, "repeater-shutdown-message-received")
          // send a message to each registry member
          group_registry.members(registry, registry_topic_heartbeats)
          |> list.each(fn(member) { process.send(member, RepeaterShutdown) })
          repeatedly.stop(state.repeater)
          actor.continue(state)
        }
        SSEHeartbeat -> {
          logging.log(logging.Error, "repeater-sse-heartbeat-message-received")
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
  HeartbeatMessage(tag: String, xuid: uuid.Uuid)
}

pub type EventState {
  EventState(count: Int, sse_id: uuid.Uuid)
}

fn sse_init(
  reg_name: process.Name(group_registry.Message(RegistryMsg)),
  subj: process.Subject(RegistryMsg),
) {
  let sse_id = uuid.v4()
  let registry = group_registry.get_registry(reg_name)
  let assert Ok(owner) = process.subject_owner(subj)
  let group_reg =
    group_registry.join(registry, registry_topic_heartbeats, owner)
  let selector =
    process.new_selector()
    |> process.select(group_reg)
  actor.initialised(EventState(count: 0, sse_id:))
  |> actor.returning(subj)
  |> actor.selecting(selector)
  |> Ok
}

fn sse_loop(
  state: EventState,
  message: RegistryMsg,
  conn: mist.SSEConnection,
) -> actor.Next(EventState, RegistryMsg) {
  case message {
    SSEHeartbeat -> {
      logging.log(logging.Debug, "sse-loop-sse-heartbeat-message-received")
      let event =
        mist.event("heartbeat" |> string_tree.from_string)
        |> mist.event_id(state.count |> int.to_string)
        |> mist.event_name("heartbeat")
      case mist.send_event(conn, event) {
        Ok(_) -> {
          logging.log(logging.Debug, "sse-loop-sse-heartbeat-message-mist-send-ok")
          actor.continue(EventState(..state, count: state.count + 1))
        }
        Error(_) -> {
          logging.log(logging.Error, "sse-loop-sse-heartbeat-message-mist-send-error")
          actor.stop()
        }
      }
    }
    RepeaterShutdown -> {
      logging.log(logging.Debug, "sse-loop-shutdown-message-received")
      actor.stop()
    }
    RepeaterTriggerHeartbeat -> {
      logging.log(logging.Error, "sse-loop-repeater-trigger-heartbeat-received")
      actor.continue(state)
    }
  }
}
