import envoy
import ewe
import filepath
import gleam/erlang/application
import gleam/erlang/atom
import gleam/erlang/process
import gleam/http/request
import gleam/http/response
import gleam/int
import gleam/list
import gleam/otp/actor
import gleam/otp/static_supervisor as supervisor
import gleam/result
import gleam/string
import logging
import simplifile
import wisp
import wisp_ewe

pub const app_prefix = "BE_APP_"

fn get_env_int(key: String, default: Int, elide: Bool) -> Int {
  let viewable_default = case elide {
    True -> "elided"
    False -> default |> int.to_string
  }
  case envoy.get(key) {
    Ok(v) -> {
      case v |> int.parse {
        Ok(v2) -> v2
        Error(_) -> {
          logging.log(
            logging.Warning,
            "failed to parse int from env key: "
              <> key
              <> ", using default: "
              <> viewable_default,
          )
          default
        }
      }
    }
    Error(_) -> {
      logging.log(
        logging.Warning,
        "failed to find env key: "
          <> key
          <> ", using default: "
          <> viewable_default,
      )
      default
    }
  }
}

fn get_env_str(key: String, default: String, elide: Bool) -> String {
  let viewable_default = case elide {
    True -> "elided"
    False -> default
  }
  case envoy.get(key) {
    Ok(v) -> v
    Error(_) -> {
      logging.log(
        logging.Warning,
        "failed to find env key: "
          <> key
          <> ", using default: "
          <> viewable_default,
      )
      default
    }
  }
}

fn get_log_level(key: String) -> logging.LogLevel {
  case key |> string.lowercase {
    "emergency" -> logging.Emergency
    "alert" -> logging.Alert
    "critical" -> logging.Critical
    "error" -> logging.Error
    "warning" -> logging.Warning
    "notice" -> logging.Notice
    "info" -> logging.Info
    "debug" -> logging.Debug
    _ -> logging.Info
  }
}

pub type AppError {
  UnableToFindPrivDir(app_name: String, nil: Nil)
  UnableToReadJson(file: String, error: simplifile.FileError)
}

/// The Erlang/OTP application start callback. Starts the top supervisor and
/// hands its pid back to the application controller.
pub fn start(_type: a, _args: b) -> Result(process.Pid, actor.StartError) {
  // get nice logging from wisp
  wisp.configure_logger()

  // update logging level
  get_env_str(app_prefix <> "LOG_LEVEL", "INFO", False)
  |> get_log_level
  |> logging.set_level
  // log that the application has started
  logging.log(logging.Info, "application start called")

  // pull in a secret key from a file on disk
  // rather than env so as to not expose the secret key
  // to attackers looking at process list
  let secret_key_file =
    get_env_str(
      app_prefix <> "SECRET_KEY_FILE",
      "/secret/key/file/does/not/exist",
      False,
    )
  use secret_key_base <- result.try(
    simplifile.read(secret_key_file)
    |> result.map_error(fn(_) {
      actor.InitFailed("failed to read secret key file: " <> secret_key_file)
    }),
  )

  // get the webserver port from the environment
  // use '0.0.0.0' to bind to all ip addresses and make this server visible to the external network
  // use 'localhost' or '127.0.0.1' to make this visible only on localhost (not exposed on external network)
  let webserver_ip_address =
    get_env_str(app_prefix <> "WEBSERVER_IP_ADDRESS", "localhost", False)
  let webserver_port = get_env_int(app_prefix <> "WEBSERVER_PORT", 8080, False)

  case
    supervisor.new(supervisor.OneForOne)
    |> supervisor.add(
      combined_handler(secret_key_base)
      |> ewe.new(handler: _)
      |> ewe.bind(to: webserver_ip_address)
      |> ewe.listening(on: webserver_port)
      |> ewe.supervised,
    )
    |> supervisor.start
  {
    Ok(actor.Started(pid:, ..)) -> Ok(pid)
    Error(reason) -> Error(reason)
  }
}

/// The Erlang/OTP application stop callback, called once every process in the
/// tree is down. Any final clean up goes here.
pub fn stop(_state: a) -> atom.Atom {
  logging.log(logging.Info, "application stop called")
  atom.create("ok")
}

/// The application is already running by the time this is called, so all main
/// has left to do is keep the node alive.
pub fn main() {
  logging.log(logging.Info, "application main called")
  process.sleep_forever()
}

/// The middleware stack that the request handler uses. The stack is itself a
/// middleware function!
///
/// Middleware wrap each other, so the request travels through the stack from
/// top to bottom until it reaches the request handler, at which point the
/// response travels back up through the stack.
/// 
/// The middleware used here are the ones that are suitable for use in your
/// typical web application.
///
fn wisp_middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  // Permit browsers to simulate methods other than GET and POST using the
  // `_method` query parameter.
  let req = wisp.method_override(req)

  // Log information about the request and response.
  use <- wisp.log_request(req)

  // Return a default 500 response if the request handler crashes.
  use <- wisp.rescue_crashes

  // Rewrite HEAD requests to GET requests and return an empty body.
  use req <- wisp.handle_head(req)

  // Known-header based CSRF protection for non-HEAD/GET requests
  use req <- wisp.csrf_known_header_protection(req)

  // Handle the request!
  handle_request(req)
}

fn combined_handler(
  secret_key_base: String,
) -> fn(request.Request(ewe.Connection)) -> response.Response(ewe.Body) {
  fn(req: request.Request(ewe.Connection)) {
    logging.log(logging.Debug, "combined_handler called, req.path=" <> req.path)
    case req |> request.path_segments |> list.first {
      // forward api requests to wisp handler
      Ok("api") ->
        wisp_ewe.create_handler(wisp_handle_api_requests, secret_key_base)(req)
      // forward all remaining requests to ewe, for things like websockets, streaming, sse, etc.
      _ -> ewe_handle_request(req)
    }
  }
}

/// handle wisp requests
fn wisp_handle_api_requests(
  request: request.Request(wisp.Connection),
) -> response.Response(wisp.Body) {
  logging.log(logging.Debug, "wisp_handle_api_requests called")
  // Apply the middleware stack for this request/response.
  use req <- wisp_middleware(request)

  case req |> request.path_segments {
    ["api", "v1"] -> wisp.html_response("<h1>api/v1 : (wisp + ewe)</h1>", 200)
    ["api", "v1", "jobs"] -> list_jobs()
    ["api", "v2"] ->
      wisp.html_response("<h1>Error: api/v2 not yet supported.</h1>", 200)
    _ ->
      wisp.html_response(
        "<h1>Error: must specify api/[VERSION] in path. Only VERSION=v1 currently supported.</h1>",
        500,
      )
  }
}

fn list_jobs() -> response.Response(wisp.Body) {
  let app_name = "be_app_name"
  let jobs_file = "jobs.json"

  case
    app_name
    |> application.priv_directory
    |> result.map_error(UnableToFindPrivDir(app_name, _))
    |> result.map(filepath.join(_, jobs_file))
    |> result.try(fn(f) {
      simplifile.read(f) |> result.map_error(UnableToReadJson(f, _))
    })
  {
    Ok(json_data) -> wisp.json_response(json_data, 200)
    Error(e) -> {
      logging.log(
        logging.Warning,
        "failed to list jobs, error: " <> e |> string.inspect,
      )
      wisp.json_response("", 500)
    }
  }
}

/// handle ewe requests
fn ewe_handle_request(
  request: request.Request(ewe.Connection),
) -> response.Response(ewe.Body) {
  // TODO: insert ewe request handlers here
  logging.log(logging.Info, "ewe_handle_request: " <> request.path)
  // Give every body a `content-type`. ewe writes `content-length` and
  // `transfer-encoding` itself, ypu don't need to specify those headers.
  response.new(200)
  |> response.set_header("content-type", "text/plain; charset=utf-8")
  |> response.set_body(ewe.Text("Hello, World!"))
}
