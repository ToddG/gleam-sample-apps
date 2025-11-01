# etl

[A simple ETL (stub) in gleam](src/etl.gleam). See the [test](test/etl_test.gleam) for how to configure and use this
thingy.

This is just a stub ETL. I wrote it to show how one could/should wire up this type of application.

## Development

```sh
gleam test   # test the project
```

Outputs:
```bash

warning: Unused imported module
  ┌─ /media/toddg/data1/repos/personal/gleam/gleam-sample-apps/etl/src/etl.gleam:1:1
  │
1 │ import gleam/io
  │ ^^^^^^^^^^^^^^^ This imported module is never used

Hint: You can safely remove it.

   Compiled in 0.03s
    Running etl_test.main
[1;34mINFO[0m TODO: implement download resources, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: save resource to temp file, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: parse data into the foo type constructor, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: load file into db, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: archive temp file to archive file, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: delete temp file, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: emit metrics, config=Config{
	'source':FooSourceResource(ResourceUrl(Url("https://source/foo/abc.input")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input")))
	'archive':ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo")))
}
[1;34mINFO[0m TODO: implement download resources, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: save resource to temp file, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: parse data into the bar type constructor, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: load file into db, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: archive temp file to archive file, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: delete temp file, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[1;34mINFO[0m TODO: emit metrics, config=Config{
	'source':BarSourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))
	'temp':TempResource(ResourceLocalFile(LocalFilePath("./temp/bar/abc.input")))
	'archive':ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo")))
}
[32m.[39m[32m
1 tests, no failures[39m
```

## Notes

* [Discussion thread for the evolution of this sample app]()(https://discordapp.com/channels/768594524158427167/1432462826500263976/1432724667067535421)
