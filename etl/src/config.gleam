import gleam/string
import resource.{type ArchiveResource, type SourceResource, type TempResource}

pub opaque type Config {
  Config(source: SourceResource, temp: TempResource, archive: ArchiveResource)
}

pub fn new_config(
  source: SourceResource,
  temp: TempResource,
  archive: ArchiveResource,
) -> Config {
  // TODO: validate source (file/url) exists
  // TODO: validate temp dir exists (will overwrite temp file)
  // TODO: validate archive dir exists, file does not exist (will not overwrite archive file)
  Config(source:, temp:, archive:)
}

pub fn to_string(config: Config) -> String {
  "Config{\n\t'source':"
  <> string.inspect(config.source)
  <> "\n\t'temp':"
  <> string.inspect(config.temp)
  <> "\n\t'archive':"
  <> string.inspect(config.archive)
  <> "\n}"
}

pub fn get_source(config: Config) -> SourceResource {
  config.source
}

pub fn get_temp(config: Config) -> TempResource {
  config.temp
}

pub fn get_archive(config: Config) -> ArchiveResource {
  config.archive
}
