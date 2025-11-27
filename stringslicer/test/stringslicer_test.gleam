import gleeunit
import gleam/string

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn slice_test() {
  assert string.slice("gleam", at_index: 1, length: 2) == "le"

  assert string.slice("gleam", at_index: 1, length: 10) == "leam"

  assert string.slice("gleam", at_index: 10, length: 3) == ""

  assert string.slice("gleam", at_index: -2, length: 2) == "am"

  assert string.slice("gleam", at_index: -12, length: 2) == ""

  assert string.slice("gleam", at_index: 2, length: -3) == ""

  assert string.slice("gleam", at_index: 2, length: 0) == ""

  assert string.slice("👶🏿", at_index: 0, length: 3) == "👶🏿"
}
