import gleam/dynamic/decode
import rsvp
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
  type Model, type Msg, type Route, IdPReturned, LoggedIn, Login, LoginData,
  Model, OnRouteChange, UserSubmittedForm, Wibble, Wobble,User
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
  io.println("on_url_change, uri=" <> string.inspect(uri))
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
    UserSubmittedForm(Ok(LoginData(username, password))) -> {
      // form validation succeeded, so submit the form to identity provider
      #(
        model,
        login.authenticate_with_idp(username, password, models.IdPReturned),
      )
    }
    UserSubmittedForm(Error(form)) -> {
      // form validation failed - store the form in the model to show the errors.
      #(Model(route: Login, user: None, errors: Some(form)), effect.none())
    }
    IdPReturned(Ok(user)) -> {
      #(Model(..model, user: Some(user)), modem.push("loggedin", None, None))
    }
    IdPReturned(Error(error)) -> {
      io.println("error=" <> string.inspect(error))
      // TODO : push the error to the end user in a toast or something
      #(Model(route: Login, user: None, errors: None), effect.none())
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
          Some(user) -> user.username
        })
    },
  ])
}
