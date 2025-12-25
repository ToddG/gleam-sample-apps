import gleam/string
import gleam/int
import gleam/io
import lustre
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import gleam/option.{type Option}
import gleam/javascript/promise.{type Promise}

// ------------------------------------------------------------------
// ffi
// ------------------------------------------------------------------
@external(javascript, "./auth0_wrapper.js", "init")
fn js_init_auth0(config: InitConfig) -> Promise(Result(String, String)) {
  promise.resolve(Error("unkown error, config=" <> string.inspect(config)))
}

// ------------------------------------------------------------------
// ffi wrapper
// ------------------------------------------------------------------
pub fn init_auth0(config: InitConfig) -> Effect(Msg) {
  use dispatch <- effect.from
  let p = js_init_auth0(config)
  promise.await(p, fn(result) { dispatch(common.Auth0PromiseInit(result)) })
}

/// The `Msg` type describes all the ways the outside world can talk to our app.
/// That includes user input, network requests, and any other external events.
///

/// Minimal options required to create an Auth0 client.
pub type InitConfig {
  InitConfig(
  domain: String,
  client_id: String,
  redirect_uri: String,
  audience: Option(String),
  scope: Option(String),
  )
}


pub type AppError {
  Auth0Error(s: String)
}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

/// The `Model` is the state of our entire application.
///
type Model =
  Int

/// The `init` function gets called when we first start our app. It sets the
/// initial state of the app.
///
fn init(_) -> #(Model, Effect(Msg)) {
  #(0, effect.none())
}

// UPDATE ----------------------------------------------------------------------
pub type Msg {
  UserClickedIncrement
  UserClickedDecrement
  Auth0PromiseInit(result: Result(String, String))
}

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserClickedIncrement -> {
      #(model + 1, effect.none())
    }
    UserClickedDecrement -> {
      #(model - 1, effect.none())
    }
    Auth0PromiseInit(result) -> {
      io.println("Auth0PromiseInit result=" <> string.inspect(result))
      #(model, effect.none())
    }
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model)

  html.div([], [
    html.button([event.on_click(UserClickedDecrement)], [html.text("-")]),
    html.p([], [html.text("Count: "), html.text(count)]),
    html.button([event.on_click(UserClickedIncrement)], [html.text("+")]),
  ])
}
