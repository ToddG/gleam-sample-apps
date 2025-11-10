import gleam/dynamic/decode
import gleam/json
import gleeunit
import testjsondecoder.{
  Gold, boolean_field_decoder, color_field_decoder,
  foo_field_decoder, schema_decoder
}

const data = "
{
  \"boolean\": true,
  \"color\": \"gold\",
  \"null\": null,
  \"number\": 123,
  \"foo\": {
    \"boolean\": false,
    \"a\": \"b\",
    \"c\": \"d\",
    \"nested1\": {
      \"nested2\": {
        \"array\": [
          1,
          2,
          3
        ]
      }
    }
  },
  \"string\": \"Hello World\"
}
"

pub fn main() -> Nil {
  gleeunit.main()
}

// ------------------------------------------------------------------
// isolated unit tests
// ------------------------------------------------------------------

pub fn boolean_decoding_true_test() {
  assert json.parse(
      "{ \"boolean\": true }",
      boolean_field_decoder(decode.success),
    )
    == Ok(True)
  assert json.parse(data, boolean_field_decoder(decode.success)) == Ok(True)
}

pub fn boolean_decoding_false_test() {
  assert json.parse(
      "{ \"boolean\": false }",
      boolean_field_decoder(decode.success),
    )
    == Ok(False)
}

pub fn color_decoding_test() {
  assert json.parse(
      "{ \"color\": \"gold\" }",
      color_field_decoder(decode.success),
    )
    == Ok(Gold)
  assert json.parse(data, color_field_decoder(decode.success)) == Ok(Gold)
}

pub fn foo_decoding_test() {
  let assert Ok(foo) = json.parse(data, foo_field_decoder(decode.success))
  assert foo.boolean == False
  assert foo.a == "b"
  assert foo.c == "d"
}

pub fn schema_decoding_test() {
  let assert Ok(schema) = json.parse(data, schema_decoder())
  assert schema.boolean == True
  assert schema.color == Gold
  assert schema.foo.boolean == False
  assert schema.foo.a == "b"
  assert schema.foo.c == "d"
}

// ------------------------------------------------------------------
// partial (iterative testing)
// ------------------------------------------------------------------
pub fn boolean_and_color_decoding_test() {
  assert json.parse("{ \"boolean\": true, \"color\": \"gold\" }", {
      use boolean <- boolean_field_decoder()
      use color <- color_field_decoder()
      decode.success(#(boolean, color))
    })
    == Ok(#(True, Gold))
  assert json.parse(data, {
    use boolean <- boolean_field_decoder()
    use color <- color_field_decoder()
    decode.success(#(boolean, color))
  })
  == Ok(#(True, Gold))
}
