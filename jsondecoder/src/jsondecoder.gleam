import gleam/io

pub fn main() -> Nil {
  io.println("Hello from jsondecoder!")
}

pub opaque type PositiveInt {
  PositiveInt(Int)
}

