// IMPORTS ---------------------------------------------------------------------

import gleam/int
import gleam/string
import leaflet_ffi
import logger_ffi as logger
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// CONSTANTS--------------------------------------------------------------------

const gleam_url = "https://gleam.run"

const javascript_url = "https://gleam.run/news/v0.16-gleam-compiles-to-javascript/"

const lustre_url = "https://hexdocs.pm/lustre/index.html"

const pico_css_url = "https://picocss.com"

// MAIN ------------------------------------------------------------------------

pub fn main() {
  logger.debug("application starting...")
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

// MODEL -----------------------------------------------------------------------

/// The `Model` is the state of our entire application.
///
type CurrentPage {
  DemoPage
  MapPage
}

type Model {
  Model(counter: Int, page: CurrentPage)
}

/// The `init` function gets called when we first start our app. It sets the
/// initial state of the app.
///
fn init(_) -> #(Model, Effect(msg)) {
  let effect = setup_map()
  #(Model(0, MapPage), effect)
}

fn setup_map() {
  use _, _ <- effect.before_paint
  logger.debug("setup leaflet map")
  leaflet_ffi.new_map("mapleaflet")
  Nil
}

// UPDATE ----------------------------------------------------------------------

/// The `Msg` type describes all the ways the outside world can talk to our app.
/// That includes user input, network requests, and any other external events.
///
type Msg {
  UserSelectedIncrement
  UserSelectedDecrement
  UserSelectedDemoPage
  UserSelectedMapPage
}

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> #(Model, Effect(msg)) {
  let end_state = case msg {
    UserSelectedIncrement -> #(
      Model(..model, counter: model.counter + 1),
      effect.none(),
    )
    UserSelectedDecrement -> #(
      Model(..model, counter: model.counter - 1),
      effect.none(),
    )
    UserSelectedDemoPage -> #(Model(..model, page: DemoPage), effect.none())
    UserSelectedMapPage -> #(Model(..model, page: MapPage), effect.none())
  }
  logger.debug(
    "update: msg="
    <> string.inspect(msg)
    <> ", start_state="
    <> string.inspect(model)
    <> ", end state="
    <> string.inspect(end_state),
  )
  end_state
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  html.body([], [html_header(), html_navbar(), html_main(model), html_footer()])
}

fn html_footer() -> Element(Msg) {
  html.footer([], [])
}

fn html_main(model: Model) -> Element(Msg) {
  html.main([attribute.id("app-main"), attribute.class("container-fluid")], [
    html_demo_section(model),
    html_map_section(model),
  ])
}

fn html_header() -> Element(Msg) {
  html.header([], [
    html.h1([attribute.id("app-header")], [html.text("DEMO App")]),
  ])
}

fn html_navbar() -> Element(Msg) {
  html.nav([attribute.id("app-navbar"), attribute.class("grid")], [
    html_button(UserSelectedDemoPage, "DemoPage"),
    html_button(UserSelectedMapPage, "MapPage"),
  ])
}

fn html_map_section(model: Model) -> Element(Msg) {
  case model.page {
    MapPage -> {
      html.section([attribute.id("map-section"), attribute.style("display", "block")], [
        leaflet_map_div()
      ])
    }
    _ -> {
      html.section([attribute.id("map-section"), attribute.style("display", "none")], [
        leaflet_map_div()
      ])
    }
  }
}

fn leaflet_map_div() -> Element(Msg) {
    element.unsafe_raw_html(
      "",
      "div",
      [attribute.id("mapleaflet")],
      "",
    )
}

fn html_demo_section(model: Model) -> Element(Msg) {
  case model.page {
    DemoPage -> {
      let counter = int.to_string(model.counter)
      html.section([attribute.id("demo-section")], [
        html.ul([], [
          html_link_li(gleam_url, "Gleam"),
          html_link_li(javascript_url, "Javascript"),
          html_link_li(lustre_url, "Lustre"),
          html_link_li(pico_css_url, "Pico"),
        ]),
        html.div([attribute.class("grid")], [
          html_image(gleam_url, "/src/assets/gleam.svg"),
          html_image(javascript_url, "/src/assets/javascript.svg"),
          html_image(lustre_url, "/src/assets/lustre.png"),
          html_image(pico_css_url, "/src/assets/pico.svg"),
        ]),
        html.div([attribute.class("grid")], [
          html_button(UserSelectedIncrement, "+"),
          html.p([], [html.text("counter: "), html.text(counter)]),
          html_button(UserSelectedDecrement, "-"),
        ]),
      ])
    }
    _ -> {
      html.section([attribute.id("demo-section")], [])
    }
  }
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
