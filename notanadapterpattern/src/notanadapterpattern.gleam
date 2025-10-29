import gleam/erlang/process
import gleam/result
import gleam/string
import logging

// ------------------------------------------------------------------
// main
// ------------------------------------------------------------------
pub fn main() -> Nil {
  logging.configure()
  logging.log(logging.Info, "Hello from notanadapterpattern!")
  let foo_config: Config =
    Config(
      source: FooSourceResource(
        SourceResource(ResourceUrl(Url("https://source/foo/abc.input"))),
      ),
      temp: TempResource(
        ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")),
      ),
      archive: ArchiveResource(ResourceRemoteFile(
        RemoteFilePath("./archive/foo/abc.input"),
        config: SSHConfig("todo"),
      )),
    )

  let bar_config: Config =
    Config(
      source: BarSourceResource(
        SourceResource(ResourceRemoteFile(
          RemoteFilePath("foo@bar:/a/path/def.input"),
          config: SSHConfig("todo"),
        )),
      ),
      temp: TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))),
      archive: ArchiveResource(ResourceS3(
        bucket: "not-an-adapter-pattern-archive",
        object: "bar/def.input",
        config: S3Config("todo"),
      )),
    )

  let _ = process(foo_config)
  let _ = process(bar_config)

  // sleep so all the logs have a chance
  process.sleep(1000)
}

// ------------------------------------------------------------------
// external data feed types that this generic scraper supports
// ------------------------------------------------------------------
// external json feed is consumed as data
pub type Data {
  // external json looks like this: {"a": 123}
  FooData(String)
  // external json looks like this: {"b": "abc"}
  BarData(String)
}

// data is parsed into a schema
pub type Schema {
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
pub type KeyPath {
  KeyPath(String)
}

pub type DbAdded {
  DbAdded(Int)
}

pub type DbIgnored {
  DbIgnored(Int)
}

pub type DatabaseUrl {
  DatabaseUrl(String)
}

pub type DatabaseTableName {
  DatabaseTableName(String)
}

pub type RemoteFilePath {
  RemoteFilePath(String)
}

pub type LocalFilePath {
  LocalFilePath(String)
}

pub type SSHConfig {
  SSHConfig(String)
}

pub type S3Config {
  S3Config(String)
}

pub type Url {
  Url(String)
}

pub type Resource {
  ResourceUrl(Url)
  ResourceLocalFile(LocalFilePath)
  ResourceRemoteFile(RemoteFilePath, config: SSHConfig)
  ResourceS3(bucket: String, object: String, config: S3Config)
}

pub type SourceResource {
  SourceResource(Resource)
}

pub type TypedSourceResource {
  FooSourceResource(SourceResource)
  BarSourceResource(SourceResource)
}

pub type TempResource {
  TempResource(Resource)
}

pub type ArchiveResource {
  ArchiveResource(Resource)
}

// SourceType is used to map the retrieved data to a processor.
// So a `Foo` SourceType will be processed by `parse_foo(...)` function,
// and a `Bar` SourceType will be processed by a `parse_bar(...) function, etc.
pub type SourceType {
  Foo(String)
  Bar(String)
}

pub type Config {
  Config(
    source: TypedSourceResource,
    temp: TempResource,
    archive: ArchiveResource,
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
  let _ =
    validate_config(config)
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
  logging.log(
    logging.Info,
    "TODO: emit metrics, config=" <> string.inspect(config),
  )
  Ok(#(data, config))
}

fn delete_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: delete temp file
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: delete temp file, config=" <> string.inspect(config),
  )
  Ok(#(data, config))
}

fn archive_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: archive temp file
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: archive temp file to archive file="
      <> string.inspect(config.archive)
      <> ", config="
      <> string.inspect(config),
  )
  Ok(#(data, config))
}

fn load_file_into_database(
  value: #(t, Config),
) -> Result(#(t, Config), ScraperError) {
  // TODO: load file into db
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: load file into db, config=" <> string.inspect(config),
  )
  Ok(#(data, config))
}

fn parse_foo(
  _data: Data,
  config: Config,
) -> Result(#(Schema, Config), ScraperError) {
  // TODO: parse data into the foo type constructor
  logging.log(
    logging.Info,
    "TODO: parse data into the foo type constructor, config="
      <> string.inspect(config),
  )
  Ok(#(FooSchema(0), config))
}

fn parse_bar(
  _data: Data,
  config: Config,
) -> Result(#(Schema, Config), ScraperError) {
  // TODO: parse data into the bar type constructor
  logging.log(
    logging.Info,
    "TODO: parse data into the bar type constructor, config="
      <> string.inspect(config),
  )
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
  logging.log(
    logging.Info,
    "TODO: save resource to temp file="
      <> string.inspect(config.temp)
      <> ", config="
      <> string.inspect(config),
  )
  Ok(#(data, config))
}

fn download_resource(config: Config) -> Result(#(Data, Config), ScraperError) {
  // TODO: download resource
  logging.log(
    logging.Info,
    "TODO: implement download resources, config=" <> string.inspect(config),
  )
  case config.source {
    FooSourceResource(SourceResource(resource)) ->
      Ok(#(
        FooData("processed foo resource =" <> string.inspect(resource)),
        config,
      ))
    BarSourceResource(SourceResource(resource)) ->
      Ok(#(
        BarData("processed bar resource =" <> string.inspect(resource)),
        config,
      ))
  }
}

fn validate_config(config: Config) -> Result(Config, ScraperError) {
  // TODO: verify source files exists
  // TODO: verify target file does not exist
  // TODO: etc.
  logging.log(
    logging.Info,
    "TODO: implement validate_config, config=" <> string.inspect(config),
  )
  Ok(config)
}
