//// this is a working version using nested trys

import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/string_tree
import handles
import handles/ctx
import handles/error
import logging
import simplifile

pub type AppError {
  CouldNotCompileTemplate(error: error.TokenizerError)
  CouldNotEvaluateTemplate(error: error.RuntimeError)
  CouldNotReadFile(error: simplifile.FileError, file: String)
  CouldNotReadTemplate(error: AppError)
}

pub fn main() -> Result(String, AppError) {
  io.println("Hello from myhandles!")

  let context =
    ctx.Dict([
      ctx.Prop("key", ctx.Str("KEYABC")),
      ctx.Prop("value", ctx.Str("VALUEABC")),
    ])

  echo "test 01"
  echo reify_template_to_string1(context, "./priv/template01.tmplt")

  echo "test 02"
  echo reify_template_to_string2(context, "./priv/template01.tmplt")
}

// this is a working version using the `use` keyword
fn reify_template_to_string1(
  context: ctx.Value,
  template_path: String,
) -> Result(String, AppError) {
  use text <- result.try(
    template_path
    |> read_file
    |> result.map_error(CouldNotReadTemplate),
  )

  use compiled_template <- result.try(
    handles.prepare(text)
    |> result.map_error(CouldNotCompileTemplate),
  )

  use output <- result.try(
    handles.run(compiled_template, context, [])
    |> result.map_error(CouldNotEvaluateTemplate),
  )

  Ok(string_tree.to_string(output))
}

fn reify_template_to_string2(
  context: ctx.Value,
  template_path: String,
) -> Result(String, AppError) {
  template_path
  |> read_file
  |> result.map_error(CouldNotReadTemplate)
  |> result.try(fn(text){
    text
    |> handles.prepare
    |> result.map_error(CouldNotCompileTemplate)
    |> result.try(fn(compiled_template){
      compiled_template
      |> handles.run(context, [])
      |> result.map_error(CouldNotEvaluateTemplate)
      |> result.try(fn(generated_text){
        generated_text
        |> string_tree.to_string
        |> Ok
      })
    })
  })
}

fn read_file(path: String) -> Result(String, AppError) {
  path
  |> simplifile.read
  |> result.map_error(CouldNotReadFile(_, path))
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
