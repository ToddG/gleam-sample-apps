import gleam/dynamic/decode.{type Decoder}
import gleam/io
import gleam/string
import simplifile

// ------------------------------------------------------------------
// types
// ------------------------------------------------------------------
pub type Schema {
  Schema(boolean: Bool, color: Color, foo: Foo)
}

pub type Foo {
  Foo(boolean: Bool, a: String, c: String)
}

pub type Color {
  Gold
}


// ------------------------------------------------------------------
// main
// ------------------------------------------------------------------
pub fn main() -> Nil {
  let assert Ok(data) = simplifile.read(from: "./priv/sampledata.json")
  io.println(data)
}

// ------------------------------------------------------------------
// decoders
// ------------------------------------------------------------------
pub fn boolean_decoder() -> Decoder(Bool) {
  use val <- decode.then(decode.bool)
  decode.success(val)
}

pub fn boolean_field_decoder(next: fn(Bool) -> Decoder(a)) -> Decoder(a) {
  decode.field("boolean", boolean_decoder(), next)
}

pub fn color_decoder() -> Decoder(Color) {
  use color <- decode.then(decode.string)
  case string.lowercase(color) {
    "gold" -> decode.success(Gold)
    _ -> decode.failure(Gold, "Color")
  }
}

pub fn color_field_decoder(next: fn(Color) -> Decoder(a)) -> Decoder(a) {
  decode.field("color", color_decoder(), next)
}

pub fn foo_decoder() -> Decoder(Foo){
  use boolean <- boolean_field_decoder
  use a <- decode.field("a", decode.string)
  use c <- decode.field("c", decode.string)
  decode.success(Foo(boolean, a, c))
}

pub fn foo_field_decoder(next: fn(Foo) -> Decoder(a)) -> Decoder(a) {
  decode.field("foo", foo_decoder(), next)
}

pub fn schema_decoder() -> Decoder(Schema) {
  use boolean <- boolean_field_decoder()
  use color <- color_field_decoder()
  use foo <- foo_field_decoder()
  decode.success(Schema(boolean:, color:, foo:))
}
