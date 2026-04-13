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

  echo "test 03 -- missing file"
  echo reify_template_to_string1(context, "non-existent-file")

  echo "test 04 -- malformed template"
  echo reify_template_to_string1(context, "./priv/malformed_template.tmplt")

  echo "test 05 -- good template, but missing keys"
  echo reify_template_to_string1(context, "./priv/missing_keys_template.tmplt")
}

pub type AppError {
  CouldNotCompileTemplate(file: String, error: error.TokenizerError)
  CouldNotEvaluateTemplate(file: String, error: error.RuntimeError)
  CouldNotReadTemplate(file: String, error: simplifile.FileError)
  CouldNotReadSomeOtherFile(file: String, error: simplifile.FileError)
}

// this is a working version using the `use` keyword
fn reify_template_to_string1(
  context: ctx.Value,
  template_path: String,
) -> Result(String, AppError) {
  use text <- result.try(
    template_path
    |> read_file(fn(file: String, error: simplifile.FileError) {
      CouldNotReadTemplate(file:, error:)
    }),
  )

  use compiled_template <- result.try(
    handles.prepare(text)
    |> result.map_error(CouldNotCompileTemplate(template_path, _)),
  )
  use output <- result.try(
    handles.run(compiled_template, context, [])
    |> result.map_error(CouldNotEvaluateTemplate(template_path, _)),
  )
  Ok(string_tree.to_string(output))
}

fn reify_template_to_string2(
  context: ctx.Value,
  template_path: String,
) -> Result(String, AppError) {
  template_path
  |> read_file(fn(file: String, error: simplifile.FileError) {
    CouldNotReadTemplate(file:, error:)
  })
  |> result.try(fn(text) {
    text
    |> handles.prepare
    |> result.map_error(CouldNotCompileTemplate(template_path, _))
    |> result.try(fn(compiled_template) {
      compiled_template
      |> handles.run(context, [])
      |> result.map_error(CouldNotEvaluateTemplate(template_path, _))
      |> result.try(fn(generated_text) {
        generated_text
        |> string_tree.to_string
        |> Ok
      })
    })
  })
}

fn read_file(
  path: String,
  on_error: fn(String, simplifile.FileError) -> AppError,
) -> Result(String, AppError) {
  path
  |> simplifile.read
  |> result.map_error(on_error(path, _))
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
