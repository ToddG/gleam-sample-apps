import config.{type Config, Config}
import etl
import external.{BarSourceResource, FooSourceResource}
import gleam/erlang/process
import gleeunit
import logging
import resource.{
  ArchiveResource, S3Bucket, S3Config, S3Object, SourceResource, TempResource,
}

pub fn main() -> Nil {
  gleeunit.main()
}

// An example of configuring and running an ETL. Normally, this would be invoked by a cron job or external
// signal of some sort.
pub fn etl_test() {
  logging.configure()

  let ssh_config = resource.SSHConfig("todo")

  let assert Ok(foo_source_url) =
    resource.new_url_resource("https://source/foo/abc.input")
  let assert Ok(foo_local_file) =
    resource.new_local_file_resource("./temp/foo/abc.input")
  let assert Ok(foo_remote_file) =
    resource.new_remote_file_resource("./archive/foo/abc.input", ssh_config)

  let foo_config: Config =
    Config(
      source: FooSourceResource(SourceResource(foo_source_url)),
      temp: TempResource(foo_local_file),
      archive: ArchiveResource(foo_remote_file),
    )

  let _ = etl.process(foo_config)

  let assert Ok(bar_source_file) =
    resource.new_remote_file_resource("foo@bar:/a/path/def.input", ssh_config)
  let assert Ok(bar_local_file) =
    resource.new_local_file_resource("./temp/bar/abc.input")
  let assert Ok(bar_remote_file) =
    resource.new_s3_resource(
      S3Bucket("not-an-adapter-pattern-archive"),
      S3Object("bar/def.input"),
      S3Config("todo"),
    )

  let bar_config: Config =
    Config(
      source: BarSourceResource(SourceResource(bar_source_file)),
      temp: TempResource(bar_local_file),
      archive: ArchiveResource(bar_remote_file),
    )

  let _ = etl.process(bar_config)

  // sleep so all the logs have a chance
  process.sleep(1000)
}
