# adapterpattern

## Development

```sh
gleam run   # Run the project
```

Outputs:

```
16:34 $ gleam run
  Compiling adapterpattern
   Compiled in 0.32s
    Running adapterpattern.main
=ERROR REPORT==== 27-Oct-2025::16:43:35.940242 ===
Hello from adapterpattern!
=ERROR REPORT==== 27-Oct-2025::16:43:35.951251 ===
file_downloader succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951330 ===
file_writer succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951399 ===
file_reader succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951437 ===
parse_foo succeeded
=ERROR REPORT==== 27-Oct-2025::16:43:35.951475 ===
data_parser:parse_foo succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951518 ===
db_persist_foo succeeded
=ERROR REPORT==== 27-Oct-2025::16:43:35.951552 ===
database_writer:persist_foo succeeded; added=0, ignored=0, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951592 ===
file_archiver succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951625 ===
file_deleter succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951677 ===
emit_metrics succeeded, config=Config("./source/foo/abc.input", "./target/foo/abc.output", "https://some/foo/out/there.abc", None, "foo")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951754 ===
file_downloader succeeded, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951797 ===
file_writer succeeded, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951835 ===
file_reader succeeded, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951867 ===
parse_bar succeeded
=ERROR REPORT==== 27-Oct-2025::16:43:35.951915 ===
data_parser:parse_bar succeeded, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
=ERROR REPORT==== 27-Oct-2025::16:43:35.951947 ===
db_persist_bar succeeded
=ERROR REPORT==== 27-Oct-2025::16:43:35.951984 ===
database_writer:persist_bar succeeded; added=0, ignored=0, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
=ERROR REPORT==== 27-Oct-2025::16:43:35.952023 ===
file_archiver succeeded, config=Config("./source/bar/abc.input", "./target/bar/abc.output", "https://some/bar/out/there.abc", None, "bar")
```

Note: switch logging from Logging.Error to Logging.Info as these methods are implemented.
