import auth0_ffi
import common.{
  type Msg, Auth0PromiseInit, Auth0PromiseLogout, UserClickedDecrement,
  UserClickedIncrement, UserClickedLogout,
}
import gleam/bool
import gleam/int
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/string
import lustre
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// ------------------------------------------------------------------
// auth0
// ------------------------------------------------------------------
pub fn init_auth0() -> Effect(Msg) {
  use dispatch <- effect.from
  auth0_ffi.init() |> promise.tap(fn(r) { Auth0PromiseInit(r) |> dispatch })
  Nil
}

pub type AppError {
  Auth0Error(s: String)
}

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
}

// MODEL -----------------------------------------------------------------------

type Model {
  Model(count: Int, logged_in: Bool)
}

fn init(_) -> #(Model, Effect(Msg)) {
  #(Model(0, False), init_auth0())
}

// UPDATE ----------------------------------------------------------------------

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserClickedIncrement -> {
      io.println("user clicked increment, model=" <> string.inspect(model))
      #(Model(..model, count: model.count + 1), effect.none())
    }
    UserClickedDecrement -> {
      io.println("user clicked decrement, model=" <> string.inspect(model))
      #(Model(..model, count: model.count - 1), effect.none())
    }
    Auth0PromiseInit(result) -> {
      io.println("Auth0PromiseInit, result=" <> string.inspect(result))
      case result {
        Ok(_) -> #(Model(..model, logged_in: True), effect.none())
        Error(_) -> #(model, effect.none())
      }
    }
    UserClickedLogout -> {
      io.println("user clicked logout, model=" <> string.inspect(model))
      #(
        model,
        effect.from(fn(dispatch) {
          auth0_ffi.logout()
          |> promise.tap(fn(r) { Auth0PromiseLogout(r) |> dispatch })
          Nil
        }),
      )
    }
    Auth0PromiseLogout(result) -> {
      io.println("Auth0PromiseLogout, result=" <> string.inspect(result))
      case result {
        Ok(_) -> #(Model(..model, logged_in: False), effect.none())
        Error(_) -> #(model, effect.none())
      }
    }
  }
}

// VIEW ------------------------------------------------------------------------

fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model.count)
  let logged_in = bool.to_string(model.logged_in)

  html.div([], [
    html.button([event.on_click(UserClickedDecrement)], [html.text("-")]),
    html.p([], [html.text("Count: "), html.text(count)]),
    html.p([], [html.text("LoggedIn: "), html.text(logged_in)]),
    html.button([event.on_click(UserClickedIncrement)], [html.text("+")]),
    html.button([event.on_click(UserClickedLogout)], [html.text("Logout")]),
  ])
}
