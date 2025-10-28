import gleam/option.{type Option, None}
import gleam/result
import logging
import gleam/string

// ------------------------------------------------------------------
// main
// ------------------------------------------------------------------
pub fn main() -> Nil {
  logging.configure()
  logging.log(logging.Info, "Hello from notanadapterpattern!")
  let foo_config: Config(Foo) =
    Config(
      source_path: SourcePath("./source/foo/abc.input"),
      target_path: TargetPath("./target/foo/abc.output"),
      url: Url("https://some/foo/out/there.abc"),
      s3config: None,
      parse_func: parse_foo
    )

  let bar_config: Config(Bar) =
    Config(
      source_path: SourcePath("./source/bar/abc.input"),
      target_path: TargetPath("./target/bar/abc.output"),
      url: Url("https://some/bar/out/there.abc"),
      s3config: None,
      parse_func: parse_bar
    )
  let _ = process(foo_config)
  let _ = process(bar_config)
  Nil
}

// ------------------------------------------------------------------
// external data feed types that this generic scraper supports
// ------------------------------------------------------------------
// external json looks like this: {"a": 123}
pub type Foo {
  Foo(Int)
}

// external json looks like this: {"b": "abc"}
pub type Bar {
  Bar(String)
}

// ------------------------------------------------------------------
// errors
// ------------------------------------------------------------------
pub type ScraperError(t) {
  ConfigError(config: Config(t), error: String)
  DownloadError(config: Config(t), error: String)
  FileWriterError(config: Config(t), error: String)
  FileReaderError(config: Config(t), error: String)
  FileArchiverError(config: Config(t), error: String)
  ParseError(config: Config(t), error: List(String))
  DatabaseError(config: Config(t), error: String)
}

// ------------------------------------------------------------------
// type aliases
// ------------------------------------------------------------------
pub type KeyPath{
  KeyPath(String)
}

pub type DbAdded{
  DbAdded(Int)
}

pub type DbIgnored{
  DbIgnored(Int)
}

pub type DatabaseUrl{
  DatabaseUrl(String)
}

pub type DatabaseTableName{
  DatabaseTableName(String)
}

pub type Data{
  Data(String)
}

pub type SourcePath{
  SourcePath(String)
}

pub type TargetPath{
  TargetPath(String)
}

pub type S3Config {
  S3Config(unknown: String)
}

pub type Url{
  Url(String)
}

pub type Config(t) {
  Config(
    source_path: SourcePath,
    target_path: TargetPath,
    url: Url,
    s3config: Option(S3Config),
    parse_func: fn(Data, Config(t)) -> Result(#(t, Config(t)), ScraperError(t)))
}

// ------------------------------------------------------------------
// Summary:
// This is a basic ETL:
// * validate the configuration
// * downloads a web resource (EXTRACT)
// * writes the file to a temporary location
// * reads the file into memory
// * parses the file (in this case assume it's json) into a data structure (TRANSFORM)
// * loads the data into a database (LOAD)
// * archive the temp file to more permanent storage
// * delete the local temp file
// * emit whatever metrics might be useful
// ------------------------------------------------------------------
pub fn process(config: Config(t)) -> Nil {
  let _ = validate_config(config)
  |> result.try(download_resource)
  |> result.try(save_resource_to_temporary_file)
  |> result.try(parse_data)
  |> result.try(load_file_into_database)
  |> result.try(archive_temp_file)
  |> result.try(delete_temp_file)
  |> result.try(emit_metrics)
  Nil
}

fn emit_metrics(value: #(t, Config(t))) -> Result(#(t, Config(t)), ScraperError(t)) {
  // TODO: emit metrics
  let #(data, config) = value
  logging.log(logging.Info, "TODO: emit metrics, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn delete_temp_file(value: #(t, Config(t))) -> Result(#(t, Config(t)), ScraperError(t)) {
  // TODO: delete temp file
  let #(data, config) = value
  logging.log(logging.Info, "TODO: delete temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn archive_temp_file(value: #(t, Config(t))) -> Result(#(t, Config(t)), ScraperError(t)) {
  // TODO: archive temp file
  let #(data, config) = value
  logging.log(logging.Info, "TODO: archive temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}


fn load_file_into_database(value: #(t, Config(t))) -> Result(#(t, Config(t)), ScraperError(t)) {
  // TODO: load file into db
  let #(data, config) = value
  logging.log(logging.Info, "TODO: load file into db, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn parse_foo(_data: Data, config: Config(Foo)) -> Result(#(Foo, Config(Foo)), ScraperError(Foo))
{
  // TODO: parse data into the foo type constructor
  logging.log(logging.Info, "TODO: parse data into the foo type constructor, config=" <> string.inspect(config))
  Ok(#(Foo(0), config))
}

fn parse_bar(_data: Data, config: Config(Bar)) -> Result(#(Bar, Config(Bar)), ScraperError(Bar))
{
  // TODO: parse data into the bar type constructor
  logging.log(logging.Info, "TODO: parse data into the bar type constructor, config=" <> string.inspect(config))
  Ok(#(Bar("testtest"), config))
}


fn parse_data(value: #(Data, Config(t))) -> Result(#(t, Config(t)), ScraperError(t)) {
  let #(data, config) = value
  config.parse_func(data, config)
}

fn save_resource_to_temporary_file(
  value: #(Data, Config(t)),
) -> Result(#(Data, Config(t)), ScraperError(t)) {
  let #(data, config) = value
  // TODO: save data to temporary file
  logging.log(logging.Info, "TODO: save resource to temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn download_resource(
  config: Config(t),
) -> Result(#(Data, Config(t)), ScraperError(t)) {
  // TODO: download resource
  logging.log(logging.Info, "TODO: implement download resources, config=" <> string.inspect(config))
  Ok(#(Data("some json data"), config))
}

fn validate_config(config: Config(t)) -> Result(Config(t), ScraperError(t)) {
  // TODO: verify source files exists
  // TODO: verify target file does not exist
  // TODO: etc.
  logging.log(logging.Info, "TODO: implement validate_config, config=" <> string.inspect(config))
  Ok(config)
}
