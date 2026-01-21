import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import models.{type Msg}

pub fn display_element() -> Element(Msg) {
  html.h1(
    [
      attribute.class(
        "text-6xl font-bold underline bg-green-700 fill-amber-500",
      ),
    ],
    [element.text("You're on wobble")],
  )
}
