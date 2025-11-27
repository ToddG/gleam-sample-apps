import gleam/list
import gleam/io
import gleam/string

pub fn main() -> Nil {
  io.println("Hello from stringslicer!")
  let s = "abc;def"
  io.println("s=" <> s <> ", at_index=-1, length=2")
  let slice = string.slice(s, at_index: 4, length: 2)
  io.println("slice=" <> slice)
  "((1.0 2.0,2.5 0.1,-7.0 -4.0)),((2.0 2.1,0.9 -0.5,10.0 -3.0)),((1.0 3.4,4.5 0.0,10.0 -4.3))"
  |> string.split(")),")
  |> list.map(fn(x){
    io.println(x)
  })
  Nil
}
