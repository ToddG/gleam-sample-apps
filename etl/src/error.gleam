import config.{type Config}

pub type ScraperError {
  ConfigError(config: Config, error: String)
  DownloadError(config: Config, error: String)
  FileWriterError(config: Config, error: String)
  FileReaderError(config: Config, error: String)
  FileArchiverError(config: Config, error: String)
  ParseError(config: Config, error: List(String))
  DatabaseError(config: Config, error: String)
}
