// IMPORTS ---------------------------------------------------------------------

import gleam/int
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
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
fn init(_) -> Model {
  0
}

// UPDATE ----------------------------------------------------------------------

/// The `Msg` type describes all the ways the outside world can talk to our app.
/// That includes user input, network requests, and any other external events.
///
type Msg {
  UserClickedIncrement
  UserClickedDecrement
}

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UserClickedIncrement -> model + 1
    UserClickedDecrement -> model - 1
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  let count = int.to_string(model)
  let gleam_url = "https://gleam.run"
  let javascript_url =
    "https://gleam.run/news/v0.16-gleam-compiles-to-javascript/"
  let lustre_url = "https://hexdocs.pm/lustre/index.html"
  let pico_css_url = "https://picocss.com"
  let tauri_app_url = "https://tauri.app"

  html.body([], [
    html.header([], [
      html.h1([], [html.text("Demo App")]),
      html.ul([], [
        html_link_li(gleam_url, "Gleam"),
        html_link_li(javascript_url, "Javascript"),
        html_link_li(lustre_url, "Lustre"),
        html_link_li(pico_css_url, "Pico"),
        html_link_li(tauri_app_url, "Tauri"),
      ]),
    ]),
    html.main([attribute.class("container-fluid")], [
      html.div([attribute.class("grid")], [
        html_image(gleam_url, "/src/assets/gleam.svg"),
        html_image(javascript_url, "/src/assets/javascript.svg"),
        html_image(lustre_url, "/src/assets/lustre.png"),
        html_image(pico_css_url, "/src/assets/pico.svg"),
        html_image(tauri_app_url, "/src/assets/tauri.svg"),
      ]),
      html.div([attribute.class("grid")], [
        html_button(UserClickedIncrement, "+"),
        html.p([], [html.text("Count: "), html.text(count)]),
        html_button(UserClickedDecrement, "-"),
      ]),
    ]),
    html.footer([], []),
  ])
}

fn html_link_li(url: String, text: String) {
  html.li([], [html.a([attribute.href(url)], [html.text(text)])])
}

fn html_button(on_click: Msg, text: String) {
  html.button([event.on_click(on_click)], [html.text(text)])
}

fn html_image(url: String, image: String) {
  html.div([], [
    html.a([attribute.href(url)], [
      html.img([
        attribute.height(200),
        attribute.width(200),
        attribute.src(image),
      ]),
    ]),
  ])
}
