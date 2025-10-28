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

```
   Compiled in 0.02s
    Running notanadapterpattern.main
[1;34mINFO[0m Hello from notanadapterpattern!
[1;34mINFO[0m TODO: implement validate_config, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: implement download resources, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: save resource to temp file, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: parse data into the foo type constructor, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: load file into db, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: archive temp file, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: delete temp file, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
[1;34mINFO[0m TODO: emit metrics, config=Config(SourcePath("./source/foo/abc.input"), TargetPath("./target/foo/abc.output"), Url("https://some/foo/out/there.abc"), None, //fn(a, b) { ... })
```
