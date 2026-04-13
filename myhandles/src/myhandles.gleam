import gleam/list
import gleam/string
import gleam/result
import simplifile
import gleam/io
import handles/ctx
import handles/error
import logging

pub type AppError {
  SimplifileFileError(error: simplifile.FileError, file: String)
  HandlesTokenizerError(error: error.TokenizerError)
  HandlesRuntimeError(error: error.RuntimeError)
}

pub fn main() -> Result(String, AppError) {
  io.println("Hello from myhandles!")

  let context =
    ctx.Dict([
      ctx.Prop("key", ctx.Str("KEYABC")),
      ctx.Prop("value", ctx.Str("VALUEABC")),
    ])

  reify_template_to_string(context, "./priv/template01.tmplt")
}

fn reify_template_to_string(
  context: ctx.Value,
  template_path: String,
) -> Result(String, AppError) {
  // --------------------------------------------------------------
  // 1. this seems like a logical way to write this, but it doesn't compile
  // --------------------------------------------------------------
  //  template_path
  //  |> read_file
  //  |> result.map(handles.prepare)
  //  |> result.map_error(HandlesTokenizerError(_))
  //  |> result.map(handles.run(_, context, []))
  //  |> result.map_error(HandlesRuntimeError)
  //  |> result.map(string_tree.to_string(_))

  // --------------------------------------------------------------
  // 2. another try, this time nested, this doesn't compile either
  // --------------------------------------------------------------
  template_path
  |> read_file
  |> result.map(fn(text) {
    text
    |> handles.prepare
    |> result.map_error(HandlesTokenizerError)
    |> result.map(handles.run(_, context, []))
    |> result.map_error(HandlesRuntimeError)
    |> result.map(fn(a) { string_tree.to_string(a) |> Ok })
  })
//  |> result.flatten
}

fn read_file(path: String) -> Result(String, AppError) {
  path
  |> simplifile.read
  |> result.map_error(SimplifileFileError(_, path))
  |> result.map(fn(v) {
    debug("read file: " <> path)
    v
  })
}

fn debug(s: String) -> Nil {
  log_stuff(logging.Debug, s)
}
fn log_stuff(level: logging.LogLevel, s: String) -> Nil {
  s |> string.split("\\n") |> list.map(fn(q: String) { logging.log(level, q) })
  Nil
}
