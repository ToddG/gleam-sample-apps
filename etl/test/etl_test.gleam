import config
import etl
import gleam/erlang/process
import gleeunit
import logging
import resource.{
  ArchiveResource, BarSourceResource, FooSourceResource, LocalFilePath,
  RemoteFilePath, ResourceLocalFile, ResourceRemoteFile, ResourceS3, ResourceUrl,
  S3Bucket, S3Config, S3Object, TempResource, Url,
}

pub fn main() -> Nil {
  gleeunit.main()
}

// An example of configuring and running an ETL. Normally, this would be invoked by a cron job or external
// signal of some sort.
pub fn etl_test() {
  logging.configure()
  let ssh_config = resource.SSHConfig("todo")

  let foo_config = {
    let foo_source_url = ResourceUrl(Url("https://source/foo/abc.input"))
    let foo_local_file =
      ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))
    let foo_remote_file =
      ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), ssh_config)
    config.new_config(
      FooSourceResource(foo_source_url),
      TempResource(foo_local_file),
      ArchiveResource(foo_remote_file),
    )
  }
  let _ = etl.process(foo_config)

  let bar_config = {
    let bar_source_file =
      ResourceRemoteFile(
        RemoteFilePath("foo@bar:/a/path/def.input"),
        ssh_config,
      )
    let bar_local_file =
      ResourceLocalFile(LocalFilePath("./temp/bar/abc.input"))
    let bar_s3_file =
      ResourceS3(
        S3Bucket("not-an-adapter-pattern-archive"),
        S3Object("bar/def.input"),
        S3Config("todo"),
      )

    config.new_config(
      BarSourceResource(bar_source_file),
      TempResource(bar_local_file),
      ArchiveResource(bar_s3_file),
    )
  }

  let _ = etl.process(bar_config)

  // sleep so all the logs have a chance
  process.sleep(500)
}
