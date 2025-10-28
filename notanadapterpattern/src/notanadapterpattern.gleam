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
  let foo_config: Config =
    FooConfig(
      source_path: SourcePath("./source/foo/abc.input"),
      target_path: TargetPath("./target/foo/abc.output"),
      url: Url("https://some/foo/out/there.abc"),
      s3config: None,
    )

  let bar_config: Config =
    BarConfig(
      source_path: SourcePath("./source/bar/abc.input"),
      target_path: TargetPath("./target/bar/abc.output"),
      url: Url("https://some/bar/out/there.abc"),
      s3config: None,
    )
  let _ = process(foo_config)
  let _ = process(bar_config)
  Nil
}

// ------------------------------------------------------------------
// external data feed types that this generic scraper supports
// ------------------------------------------------------------------
// external json feed is consumed as data
pub type Data{
  // external json looks like this: {"a": 123}
  FooData(String)
  // external json looks like this: {"b": "abc"}
  BarData(String)
}

// data is parsed into a schema
pub type Schema{
  FooSchema(Int)
  BarSchema(String)
}

// ------------------------------------------------------------------
// errors
// ------------------------------------------------------------------
pub type ScraperError {
  ConfigError(config: Config, error: String)
  DownloadError(config: Config, error: String)
  FileWriterError(config: Config, error: String)
  FileReaderError(config: Config, error: String)
  FileArchiverError(config: Config, error: String)
  ParseError(config: Config, error: List(String))
  DatabaseError(config: Config, error: String)
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

pub type Config {
  FooConfig(
    source_path: SourcePath,
    target_path: TargetPath,
    url: Url,
    s3config: Option(S3Config),
  )
  BarConfig(
  source_path: SourcePath,
  target_path: TargetPath,
  url: Url,
  s3config: Option(S3Config),
  )
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
pub fn process(config: Config) -> Nil {
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

fn emit_metrics(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: emit metrics
  let #(data, config) = value
  logging.log(logging.Info, "TODO: emit metrics, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn delete_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: delete temp file
  let #(data, config) = value
  logging.log(logging.Info, "TODO: delete temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn archive_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: archive temp file
  let #(data, config) = value
  logging.log(logging.Info, "TODO: archive temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}


fn load_file_into_database(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: load file into db
  let #(data, config) = value
  logging.log(logging.Info, "TODO: load file into db, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn parse_foo(_data: Data, config: Config) -> Result(#(Schema, Config), ScraperError)
{
  // TODO: parse data into the foo type constructor
  logging.log(logging.Info, "TODO: parse data into the foo type constructor, config=" <> string.inspect(config))
  Ok(#(FooSchema(0), config))
}

fn parse_bar(_data: Data, config: Config) -> Result(#(Schema, Config), ScraperError)
{
  // TODO: parse data into the bar type constructor
  logging.log(logging.Info, "TODO: parse data into the bar type constructor, config=" <> string.inspect(config))
  Ok(#(BarSchema("testtest"), config))
}


fn parse_data(value: #(Data, Config)) -> Result(#(Schema, Config), ScraperError) {
  let #(data, config) = value
  case data {
    FooData(_) -> parse_foo(data, config)
    BarData(_) -> parse_bar(data, config)
  }
}

fn save_resource_to_temporary_file(
  value: #(Data, Config),
) -> Result(#(Data, Config), ScraperError) {
  let #(data, config) = value
  // TODO: save data to temporary file
  logging.log(logging.Info, "TODO: save resource to temp file, config=" <> string.inspect(config))
  Ok(#(data, config))
}

fn download_resource(
  config: Config,
) -> Result(#(Data, Config), ScraperError) {
  // TODO: download resource
  logging.log(logging.Info, "TODO: implement download resources, config=" <> string.inspect(config))
  case config{
    FooConfig(_,_,_,_) -> Ok(#(FooData("downloaded json data"), config))
    BarConfig(_,_,_,_) -> Ok(#(BarData("downloaded json data"), config))
  }
}

fn validate_config(config: Config) -> Result(Config, ScraperError) {
  // TODO: verify source files exists
  // TODO: verify target file does not exist
  // TODO: etc.
  logging.log(logging.Info, "TODO: implement validate_config, config=" <> string.inspect(config))
  Ok(config)
}
