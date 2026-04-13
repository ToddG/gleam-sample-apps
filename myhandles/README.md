# myhandles

[![Package Version](https://img.shields.io/hexpm/v/myhandles)](https://hex.pm/packages/myhandles)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/myhandles/)

```sh
gleam add myhandles@1
```
```gleam
import myhandles

pub fn main() -> Nil {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/myhandles>.

## Development

```sh
gleam run
```

### Success Case

```
Hello from myhandles!
src/myhandles.gleam:30
"test 01"
src/myhandles.gleam:31
Ok("KEYABC = \"VALUEABC\"\n")
src/myhandles.gleam:33
"test 02"
src/myhandles.gleam:34
Ok("KEYABC = \"VALUEABC\"\n")
```

### Error Case

```
Hello from myhandles!
src/myhandles.gleam:30
"test 01"
src/myhandles.gleam:31
Error(CouldNotReadTemplate(CouldNotReadFile(Enoent, "./priv/template01.tmplt")))
src/myhandles.gleam:33
"test 02"
src/myhandles.gleam:34
Error(CouldNotReadTemplate(CouldNotReadFile(Enoent, "./priv/template01.tmplt")))
```
