# etl

As part of creating an ETL (extract transform load), I tried to create an adapter pattern in gleam.

After [discussion with folks](https://discordapp.com/channels/768594524158427167/1432462826500263976/1432724667067535421),
I decided this was not the ideal approach.

So I created [an etl in gleam](src/etl.gleam) that does NOT use the adapter pattern, but
instead uses the `|>` pattern in gleam. I really like this, and will use it going forward.

## Development

```sh
gleam test   # test the project
```

Outputs:
```bash
   Compiled in 0.02s
    Running etl.main
INFO Hello from notanadapterpattern!
INFO TODO: implement download resources, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: save resource to temp file=TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: parse data into the foo type constructor, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: load file into db, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: archive temp file to archive file=ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))), config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: delete temp file, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: emit metrics, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
INFO TODO: implement download resources, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: save resource to temp file=TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: parse data into the bar type constructor, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: load file into db, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: archive temp file to archive file=ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))), config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: delete temp file, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
INFO TODO: emit metrics, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3(S3Bucket("not-an-adapter-pattern-archive"), S3Object("bar/def.input"), S3Config("todo"))))
```
