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

pub fn example_promise_effect(on_result: fn(Result(String, String)) -> Msg) -> Effect(Msg) {
  use dispatch <- effect.from
  do_promise() |> promise.tap(fn(r) { on_result(r) |> dispatch })
  Nil
}

pub fn testing_on_result(r: Result(String, String)) -> Msg{
    Testing(r)
}

@external(javascript, "./app.ffi.mjs", "promiseTest")
fn do_promise() -> Promise(Result(String, String))


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
  #(0, example_promise_effect(testing_on_result))
}

// UPDATE ----------------------------------------------------------------------
pub type Msg {
  Testing(r: Result(String, String))
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
    Testing(result) -> {
      io.println("Testing result=" <> string.inspect(result))
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
