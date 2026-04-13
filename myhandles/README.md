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

### Output

```
Hello from myhandles!
src/myhandles.gleam:23
"test 01"
src/myhandles.gleam:24
Ok("KEYABC = \"VALUEABC\"\n")
src/myhandles.gleam:26
"test 02"
src/myhandles.gleam:27
Ok("KEYABC = \"VALUEABC\"\n")
src/myhandles.gleam:29
"test 03 -- missing file"
src/myhandles.gleam:30
Error(CouldNotReadTemplate("non-existent-file", Enoent))
src/myhandles.gleam:32
"test 04 -- malformed template"
src/myhandles.gleam:33
Ok("{ key }} = VALUEABC\"\n")
src/myhandles.gleam:35
"test 05 -- good template, but missing keys"
src/myhandles.gleam:36
Error(CouldNotEvaluateTemplate("./priv/missing_keys_template.tmplt", UnknownProperty(2, ["bad_key"])))
```
