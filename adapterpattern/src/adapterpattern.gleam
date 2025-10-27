import gleam/int
import gleam/option.{type Option, None}
import gleam/string
import logging

pub fn main() -> Nil {
  logging.log(logging.Error, "Hello from adapterpattern!")
  let foo_config =
    Config(
      source_path: "./source/foo/abc.input",
      target_path: "./target/foo/abc.output",
      url: "https://some/foo/out/there.abc",
      s3config: None,
      data_type: "foo",
    )
  let bar_config =
    Config(
      source_path: "./source/bar/abc.input",
      target_path: "./target/bar/abc.output",
      url: "https://some/bar/out/there.abc",
      s3config: None,
      data_type: "bar",
    )
  process(foo_config)
  process(bar_config)
}

// ------------------------------------------------------------------
// orchestrator / pipeline / workflow
//
// Notes:
// -- this is where the entire workflow is wired together
// -- the advantage/idea here is that each stage of this pipeline is easily tested in isolation
// -- This is an example of the adapter pattern using constructor
// --   injection, as described in Yegor's books 1, and 2, see: https://www.yegor256.com/elegant-objects.html
// -- This pattern is also adapted from gleam dynamic decode run method, see:
// --   https://github.com/gleam-lang/stdlib/blob/126db53b626e38cd5aea98a2937a16a51662a6b6/src/gleam/dynamic/decode.gleam#L356C1-L356C4
//
// Summary:
// This is a basic ETL:
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
  let manager =
    metrics_emitter(
      file_deleter(
        file_archiver(
          database_writer(
            data_parser(file_reader(file_writer(file_downloader(config)))),
          ),
        ),
      ),
    )
  let _ = manager.run()
  Nil
}

// ------------------------------------------------------------------
// errors
// -- all scraper errors are this type
// ------------------------------------------------------------------
pub type ScraperError {
  DownloadError(config: Config, error: String)
  FileWriterError(config: Config, error: String)
  FileReaderError(config: Config, error: String)
  FileArchiverError(config: Config, error: String)
  ParseError(config: Config, error: String)
  DatabaseError(config: Config, error: String)
}

// ------------------------------------------------------------------
// type aliases
// ------------------------------------------------------------------
pub type KeyPath =
  String

pub type DbAdded =
  Int

pub type DbIgnored =
  Int

pub type DatabaseUrl =
  String

pub type DatabaseTableName =
  String

pub type Data =
  String

pub type FilePath =
  String

pub type SourcePath =
  FilePath

pub type TargetPath =
  FilePath

pub type S3Config {
  S3Config(unknown: String)
}

pub type Url =
  String

pub type Config {
  Config(
    source_path: SourcePath,
    target_path: TargetPath,
    url: Url,
    s3config: Option(S3Config),
    data_type: String,
  )
}

// ------------------------------------------------------------------
// orchestration types
// ------------------------------------------------------------------
pub type FileDownloader {
  FileDownloader(
    config: Config,
    run: fn() -> Result(#(Data, Config), List(ScraperError)),
  )
}

pub type FileWriter {
  FileWriter(
    file_downloader: FileDownloader,
    run: fn() -> Result(#(Data, Int, Config), List(ScraperError)),
  )
}

pub type FileReader {
  FileReader(
    file_writer: FileWriter,
    run: fn() -> Result(#(Data, Config), List(ScraperError)),
  )
}

pub type DataParser {
  DataParser(
    file_reader: FileReader,
    run: fn() -> Result(#(ParsedData, Config), List(ScraperError)),
  )
}

pub type DatabaseWriter {
  DatabaseWriter(
    data_parser: DataParser,
    run: fn() -> Result(#(DbAdded, DbIgnored, Config), List(ScraperError)),
  )
}

pub type FileArchiver {
  FileArchiver(
    database_writer: DatabaseWriter,
    run: fn() -> Result(Config, List(ScraperError)),
  )
}

pub type FileDeleter {
  FileDeleter(
    file_archiver: FileArchiver,
    run: fn() -> Result(Config, List(ScraperError)),
  )
}

pub opaque type MetricsEmitter {
  MetricsEmitter(
    file_deleter: FileDeleter,
    run: fn() -> Result(Config, List(ScraperError)),
  )
}

// ------------------------------------------------------------------
// constructors / run method implementations
//
// -- so the cool thing here is that the implementation code is isolated
// -- to these functions. and since each function is using the adapter
// ------------------------------------------------------------------
fn metrics_emitter(file_deleter: FileDeleter) -> MetricsEmitter {
  MetricsEmitter(file_deleter:, run: fn() {
    case file_deleter.run() {
      Ok(config) -> {
        // TODO : emit metrics
        logging.log(
          logging.Error,
          "emit_metrics succeeded, config=" <> string.inspect(config),
        )
        Ok(config)
      }
      Error(e) -> Error(e)
    }
  })
}

fn file_deleter(file_archiver: FileArchiver) -> FileDeleter {
  FileDeleter(file_archiver:, run: fn() {
    case file_archiver.run() {
      Ok(config) -> {
        // TODO : file archived, so it's safe to delete it
        logging.log(
          logging.Error,
          "file_deleter succeeded, config=" <> string.inspect(config),
        )
        Ok(config)
      }
      Error(e) -> {
        Error(e)
      }
    }
  })
}

fn file_archiver(database_writer: DatabaseWriter) -> FileArchiver {
  FileArchiver(database_writer:, run: fn() {
    case database_writer.run() {
      Ok(returned) -> {
        let #(_count_added, _count_ignored, config) = returned
        // TODO : archive file
        logging.log(
          logging.Error,
          "file_archiver succeeded, config=" <> string.inspect(config),
        )
        Ok(config)
      }
      Error(e) -> {
        Error(e)
      }
    }
  })
}

//_ -> Error([DatabaseError(config:, error:"unknown")])
fn database_writer(data_parser: DataParser) -> DatabaseWriter {
  DatabaseWriter(data_parser:, run: fn() {
    case data_parser.run() {
      Ok(returned) -> {
        let #(parsed_data, config) = returned
        case parsed_data {
          Foo(foo_data) -> {
            case db_persist_foo(foo_data) {
              Ok(db_returned) -> {
                let #(count_added, count_ignored) = db_returned
                logging.log(
                  logging.Error,
                  "database_writer:persist_foo succeeded; added="
                    <> int.to_string(count_added)
                    <> ", ignored="
                    <> int.to_string(count_ignored)
                    <> ", config="
                    <> string.inspect(config),
                )
                Ok(#(count_added, count_ignored, config))
              }
              _ -> Error([DatabaseError(config:, error: "unknown")])
            }
          }
          Bar(bar_data) -> {
            case db_persist_bar(bar_data) {
              Ok(db_returned) -> {
                let #(count_added, count_ignored) = db_returned
                logging.log(
                  logging.Error,
                  "database_writer:persist_bar succeeded; added="
                    <> int.to_string(count_added)
                    <> ", ignored="
                    <> int.to_string(count_ignored)
                    <> ", config="
                    <> string.inspect(config),
                )
                Ok(#(count_added, count_ignored, config))
              }
              _ -> Error([DatabaseError(config:, error: "unknown")])
            }
          }
        }
      }
      Error(e) -> Error(e)
    }
  })
}

fn data_parser(file_reader: FileReader) -> DataParser {
  DataParser(file_reader:, run: fn() {
    case file_reader.run() {
      Ok(returned) -> {
        let #(data, config) = returned
        // QUESTION: how do I use generics /  parametric polymorphism here?
        // https://tour.gleam.run/functions/generic-functions/
        //        case t {
        //           Foo -> {
        //             todo
        //             // TODO : parse a Foo type
        //
        //           }
        //           Bar -> {
        //             // TODO : parse a Bar type
        //           }
        //        }
        // instead, do something kludgy
        case config.data_type {
          "foo" -> {
            case parse_foo(data) {
              Ok(foo) -> {
                logging.log(
                  logging.Error,
                  "data_parser:parse_foo succeeded, config="
                    <> string.inspect(config),
                )
                Ok(#(foo, config))
              }
              Error(e) -> Error(e)
            }
          }
          "bar" -> {
            case parse_bar(data) {
              Ok(bar) -> {
                logging.log(
                  logging.Error,
                  "data_parser:parse_bar succeeded, config="
                    <> string.inspect(config),
                )
                Ok(#(bar, config))
              }
              Error(e) -> Error(e)
            }
          }
          xtype ->
            Error([
              ParseError(config, "only foo, and bar supported, not: " <> xtype),
            ])
        }
      }
      Error(e) -> {
        Error(e)
      }
    }
  })
}

fn file_reader(file_writer: FileWriter) -> FileReader {
  FileReader(file_writer:, run: fn() {
    case file_writer.run() {
      Ok(response) -> {
        let #(data, _count, config) = response
        // NOTE : we might want to do a round-trip and return data from storage
        // NOTE : for now, simply short-circuit and return the data we already have
        logging.log(
          logging.Error,
          "file_reader succeeded, config=" <> string.inspect(config),
        )
        Ok(#(data, config))
      }
      Error(e) -> {
        Error(e)
      }
    }
  })
}

fn file_writer(file_downloader: FileDownloader) -> FileWriter {
  FileWriter(file_downloader:, run: fn() {
    case file_downloader.run() {
      Ok(response) -> {
        let #(data, config) = response
        // TODO: write data to disk and return num of bytes written and config file
        logging.log(
          logging.Error,
          "file_writer succeeded, config=" <> string.inspect(config),
        )
        let temp_num_bytes_written = 0
        Ok(#(data, temp_num_bytes_written, config))
      }
      Error(e) -> {
        Error(e)
      }
    }
  })
}

fn file_downloader(config: Config) -> FileDownloader {
  FileDownloader(config:, run: fn() {
    // TODO : download file
    logging.log(
      logging.Error,
      "file_downloader succeeded, config=" <> string.inspect(config),
    )
    Ok(#("dummy data: todo: implement me", config))
  })
}

// ------------------------------------------------------------------
// external data feed types that this generic scraper supports
// ------------------------------------------------------------------
pub type ParsedData {
  // external json looks like this: {"a": 123}
  Foo(Int)
  // external json looks like this: {"b": "abc"}
  Bar(String)
}

// ------------------------------------------------------------------
// parse functions
// ------------------------------------------------------------------
fn parse_foo(_data: Data) -> Result(ParsedData, List(ScraperError)) {
  // TODO : replace with real code
  logging.log(logging.Error, "parse_foo succeeded")
  Ok(Foo(0))
}

fn parse_bar(_data: Data) -> Result(ParsedData, List(ScraperError)) {
  // TODO : replace with real code
  logging.log(logging.Error, "parse_bar succeeded")
  Ok(Bar("0"))
}

fn db_persist_foo(
  _foo_data: Int,
) -> Result(#(DbAdded, DbIgnored), List(ScraperError)) {
  // TODO: persist data into database
  logging.log(logging.Error, "db_persist_foo succeeded")
  Ok(#(0, 0))
}

fn db_persist_bar(
  _bar_data: String,
) -> Result(#(DbAdded, DbIgnored), List(ScraperError)) {
  // TODO: persist data into database
  logging.log(logging.Error, "db_persist_bar succeeded")
  Ok(#(0, 0))
}
