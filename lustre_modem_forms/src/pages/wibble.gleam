import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import models.{type Msg}

pub fn display_element() -> Element(Msg) {
  html.h1(
    [
      attribute.class(
        "text-6xl font-bold underline bg-amber-700 fill-green-500",
      ),
    ],
    [element.text("You're on wibble")],
  )
}
