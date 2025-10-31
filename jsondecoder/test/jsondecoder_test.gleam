import gleam/dynamic
import gleam/dynamic/decode.{type Decoder, DecodeError}
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import gleeunit
import logging

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn decode_test() {
  let data = dynamic.string("Hello, Joe!")
  let result = decode.run(data, decode.string)
  assert result == Ok("Hello, Joe!")
}

pub fn decode2_test() {
  let data = dynamic.int(123)
  let result = decode.run(data, decode.string)
  assert result == Error([DecodeError("String", "Int", [])])
}

pub fn decode3_test() {
  let data0 = dynamic.string("Hello, Joe!")
  let data1 = dynamic.int(1)
  let data2 = dynamic.int(2)
  let data3 = dynamic.int(3)
  let data = dynamic.list([data0, data1, data2, data3])
  let result = decode.run(data, decode.list(of: decode.int))
  assert result == Error([DecodeError("Int", "String", ["0"])])
}

pub fn decode4_test() {
  let data0 = dynamic.string("Hello, Joe!")
  let data1 = dynamic.int(1)
  let data2 = dynamic.int(2)
  let data3 = dynamic.int(3)
  let data = dynamic.list([data0, data1, data2, data3])
  let r1 = decode.run(data, decode.list(of: decode.dynamic))
  io.println(string.inspect(r1))
  case r1 {
    Ok(r1x) -> {
      let r2 = list.map(r1x, decode.run(_, decode.int))
      io.println("r2=" <> string.inspect(r2))
      list.map(r2, fn(x) {
        case x {
          Ok(z) -> io.println("Ok:" <> string.inspect(z))
          Error(e) -> io.println("Error:" <> string.inspect(e))
        }
      })
      Nil
    }
    Error(e) -> {
      io.println("error=" <> string.inspect(e))
    }
  }
}

pub opaque type PositiveInt {
  PositiveInt(Int)
}

pub fn new_positive_int(val: Int) -> Result(PositiveInt, String) {
  case is_int_positive(val) {
    True -> Ok(PositiveInt(val))
    False -> Error("Value is not positive: " <> int.to_string(val))
  }
}

pub fn is_int_positive(x: Int) -> Bool {
  x >= 0
}

pub fn positive_int_decoder(loglevel: logging.LogLevel) -> Decoder(PositiveInt) {
  use val <- decode.then(decode.int)
  case is_int_positive(val) {
    True -> decode.success(PositiveInt(val))
    False -> {
      logging.log(
        loglevel,
        "attempt to decode value="
          <> int.to_string(val)
          <> ", into PositiveInt failed",
      )
      decode.failure(PositiveInt(0), "PositiveInt")
    }
  }
}

pub fn positive_int_decoder_test() {
  let x = int.random(99) + 1
  let result = decode.run(dynamic.int(x), positive_int_decoder(logging.Error))
  assert result == Ok(PositiveInt(x))
  let y = -x
  let result = decode.run(dynamic.int(y), positive_int_decoder(logging.Error))
  assert result == Error([DecodeError("PositiveInt", "Int", [])])
}

// ------------------------------------------------------------------
// decode partially correct data
// ------------------------------------------------------------------
fn lenient_list_decoder(elem_decoder: Decoder(a)) -> Decoder(List(a)) {
  decode.list(
    decode.one_of(elem_decoder |> decode.map(list.wrap), [decode.success([])]),
  )
  |> decode.map(list.flatten)
}

pub type Feed {
  Feed(data: List(PositiveInt))
}

pub fn feed_decoder() {
  use data <- decode.field(
    "data",
    lenient_list_decoder(positive_int_decoder(logging.Error)),
  )
  decode.success(Feed(data:))
}

const good_feed = "
{
  \"data\": [
    1,
    2,
    3
  ]
}
"

pub fn good_feed_decoder_test() {
  let returned = json.parse(from: good_feed, using: feed_decoder())
  let positive_int_list = {
    [1, 2, 3]
    |> list.map(new_positive_int)
    |> result.values
  }
  let expected = Feed(data: positive_int_list)
  assert returned == Ok(expected)
}

const bad_feed = "
{
  \"data\": [
    1,
    -2,
    3
  ]
}
"

pub fn bad_feed_decoder_test() {
  let returned = json.parse(from: bad_feed, using: feed_decoder())
  let positive_int_list = {
    [1, 3]
    |> list.map(PositiveInt)
  }
  let expected = Feed(data: positive_int_list)
  assert returned == Ok(expected)
}
