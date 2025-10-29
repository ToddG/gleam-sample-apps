# notanadapterpattern

I tried to create an [adapter pattern in gleam](src/adapterpattern.gleam)

After [discussion with folks](https://discordapp.com/channels/768594524158427167/1432462826500263976/1432724667067535421),
I decided this was not the ideal approach.

So I created [not an adapter pattern in gleam](src/notanadapterpattern.gleam). I really like this, and will use this going forward.

## Development

```sh
gleam run   # Run the project
```

Outputs:


   Compiled in 0.03s
    Running notanadapterpattern.main
[1;34mINFO[0m Hello from notanadapterpattern!
[1;34mINFO[0m TODO: implement validate_config, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: implement download resources, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: save resource to temp file=TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: parse data into the foo type constructor, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: load file into db, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: archive temp file to archive file=ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))), config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: delete temp file, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: emit metrics, config=Config(FooSourceResource(SourceResource(ResourceUrl(Url("https://source/foo/abc.input")))), TempResource(ResourceLocalFile(LocalFilePath("./temp/foo/abc.input"))), ArchiveResource(ResourceRemoteFile(RemoteFilePath("./archive/foo/abc.input"), SSHConfig("todo"))))
[1;34mINFO[0m TODO: implement validate_config, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: implement download resources, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: save resource to temp file=TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: parse data into the bar type constructor, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: load file into db, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: archive temp file to archive file=ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))), config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: delete temp file, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
[1;34mINFO[0m TODO: emit metrics, config=Config(BarSourceResource(SourceResource(ResourceRemoteFile(RemoteFilePath("foo@bar:/a/path/def.input"), SSHConfig("todo")))), TempResource(ResourceLocalFile(LocalFilePath("/tmp/bar/def.input"))), ArchiveResource(ResourceS3("not-an-adapter-pattern-archive", "bar/def.input", S3Config("todo"))))
```
