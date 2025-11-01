import config.{type Config}
import error.{type ScraperError}
import gleam/result
import gleam/string
import logging
import resource.{BarSourceResource, FooSourceResource}

// ------------------------------------------------------------------
// Summary:
// This is a basic ETL:
// * configuration is opaque, so fields are already validated by field constructors
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
    Ok(config)
    |> result.try(download_resource)
    |> result.try(save_resource_to_temporary_file)
    |> result.try(parse_data)
    |> result.try(load_file_into_database)
    |> result.try(archive_temp_file)
    |> result.try(delete_temp_file)
    |> result.try(emit_metrics)
  Nil
}

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

fn emit_metrics(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: emit metrics
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: emit metrics, config=" <> config.to_string(config),
  )
  Ok(#(data, config))
}

fn delete_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: delete temp file
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: delete temp file, config=" <> config.to_string(config),
  )
  Ok(#(data, config))
}

fn archive_temp_file(value: #(t, Config)) -> Result(#(t, Config), ScraperError) {
  // TODO: archive temp file
  let #(data, config) = value
  logging.log(
    logging.Info,
    "TODO: archive temp file to archive file, config="
      <> config.to_string(config),
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
    "TODO: load file into db, config=" <> config.to_string(config),
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
      <> config.to_string(config),
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
      <> config.to_string(config),
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
    "TODO: save resource to temp file, config=" <> config.to_string(config),
  )
  Ok(#(data, config))
}

fn download_resource(config: Config) -> Result(#(Data, Config), ScraperError) {
  // TODO: download resource
  logging.log(
    logging.Info,
    "TODO: implement download resources, config=" <> config.to_string(config),
  )
  case config.get_source(config) {
    FooSourceResource(foo) ->
      Ok(#(FooData("processed foo resource =" <> string.inspect(foo)), config))
    BarSourceResource(bar) ->
      Ok(#(BarData("processed bar resource =" <> string.inspect(bar)), config))
  }
}
