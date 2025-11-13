# nesteddecoder

How does one decode a nested list of lists of lists?

```json

    \"geometry\": {
        \"rings\": [
          [
            [
              -120.719608222098,
              48.0938600886194
            ],
```

In this case, I'm curious about deeply nested json objects that resolve to various geographic entities such as points, polygons, and multi-polygons.

Thanks to the [discord thread here](https://discordapp.com/channels/768594524158427167/1438326491862794371/1438585839545352192) for helping me solve this.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
