import gleam/io
import gleam/option.{None, Some}
import gleam/string
import gleam/uri.{type Uri}
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import models.{
  type Model, type Msg, type Route, LoggedIn, Login, LoginData, Model,
  OnRouteChange, User, UserSubmittedForm, Wibble, Wobble,
}
import modem
import pages/loggedin
import pages/login
import pages/wibble
import pages/wobble

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
}

pub fn init(_) -> #(Model, Effect(Msg)) {
  let _ = modem.initial_uri()
  let route = Login
  #(Model(route:, user: None, errors: None), modem.init(on_url_change))
}

fn on_url_change(uri: Uri) -> Msg {
  case uri.path_segments(uri.path) {
    ["wibble"] -> OnRouteChange(Wibble)
    ["wobble"] -> OnRouteChange(Wobble)
    ["login"] -> OnRouteChange(Login)
    ["loggedin"] -> OnRouteChange(LoggedIn)
    _ -> OnRouteChange(Login)
  }
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  io.println(
    "model=" <> string.inspect(model) <> ", msg=" <> string.inspect(msg),
  )
  case msg {
    OnRouteChange(route) -> #(Model(..model, route:), effect.none())
    UserSubmittedForm(Ok(LoginData(username:, ..))) -> {
      // Validation succeeded - we are logged in!
      #(
        Model(route: LoggedIn, user: Some(User(username)), errors: None),
        modem.push("loggedin", None, None),
      )
    }
    UserSubmittedForm(Error(form)) -> {
      // Validation failed - store the form in the model to show the errors.
      #(Model(route: Login, user: None, errors: Some(form)), effect.none())
    }
  }
}

fn nav_element(_route: Route) -> Element(Msg) {
  html.nav([], [
    html.a(
      [
        attribute.href("/wibble"),
        attribute.class(
          "text-3xl font-bold underline bg-amber-700 fill-green-500",
        ),
      ],
      [element.text("Go to wibble")],
    ),
    html.a(
      [
        attribute.href("/wobble"),
        attribute.class(
          "text-3xl font-bold underline bg-green-700 fill-amber-500",
        ),
      ],
      [element.text("Go to wobble")],
    ),
    html.a(
      [
        attribute.href("/login"),
        attribute.class(
          "text-3xl font-bold underline bg-blue-700 fill-yellow-500",
        ),
      ],
      [element.text("Login")],
    ),
  ])
}

fn view(model: Model) -> Element(Msg) {
  html.div([], [
    nav_element(model.route),
    case model.route {
      Wibble -> wibble.display_element()
      Wobble -> wobble.display_element()
      Login ->
        login.display_element(case model.errors {
          None -> login.new_login_form()
          Some(error) -> error
        })
      LoggedIn ->
        loggedin.display_element(case model.user {
          None -> "unknown"
          Some(user) -> user.name
        })
    },
  ])
}
