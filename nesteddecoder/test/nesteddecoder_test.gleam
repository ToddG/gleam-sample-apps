import gleam/dynamic
import gleam/dynamic/decode.{DecodeError}
import gleam/json
import gleeunit
import nesteddecoder.{
  Feed, MultiPolygon, MultiPolygonGeometry, Point, Polygon, feed_decoder,
  multipolygon_decoder, point_decoder, polygon_decoder,
}

pub fn main() -> Nil {
  gleeunit.main()
}

const test_data = "
{
    \"geometry\": {
        \"rings\": [
          [
            [
              -120.719608222098,
              48.0938600886194
            ],
            [
              -120.719598093321,
              48.0938489542908
            ],
            [
              -120.719608222098,
              48.0938600886194
            ]
          ],
          [
            [
              -120.719106764279,
              48.0947538544272
            ],
            [
              -120.71911360432,
              48.0947470376596
            ],
            [
              -120.719115857178,
              48.0947663026003
            ],
            [
              -120.719106764279,
              48.0947538544272
            ]
          ]
      ]
  }
}
"

// ------------------------------------------------------------------
// point decoder tests
// ------------------------------------------------------------------
pub fn point_decoder_test() {
  let data = dynamic.list([dynamic.float(1.0), dynamic.float(2.0)])
  let result = decode.run(data, point_decoder())
  assert Ok(Point(1.0, 2.0)) == result
}

pub fn point_decoder_1_item_test() {
  let data = dynamic.list([dynamic.float(1.0)])
  let result = decode.run(data, point_decoder())
  case result {
    Ok(_) -> panic
    Error(e) -> {
      assert e == [DecodeError("Point", "List", [])]
    }
  }
}

pub fn point_decoder_3_items_test() {
  let data = dynamic.list([dynamic.float(1.0)])
  let result = decode.run(data, point_decoder())
  case result {
    Ok(_) -> panic
    Error(e) -> {
      assert e == [DecodeError("Point", "List", [])]
    }
  }
}

// ------------------------------------------------------------------
// polygon decoder tests
// ------------------------------------------------------------------
pub fn polygon_decoder_test() {
  let data =
    dynamic.list([
      dynamic.list([
        dynamic.float(1.0),
        dynamic.float(2.1),
      ]),
      dynamic.list([
        dynamic.float(2.2),
        dynamic.float(3.1),
      ]),
      dynamic.list([
        dynamic.float(0.6),
        dynamic.float(4.2),
      ]),
    ])
  let result = decode.run(data, polygon_decoder())
  assert result
    == Ok(Polygon([Point(1.0, 2.1), Point(2.2, 3.1), Point(0.6, 4.2)]))
}

// ------------------------------------------------------------------
// multipolygon decoder tests
// ------------------------------------------------------------------
pub fn multipolygon_decoder_test() {
  let data =
    dynamic.list([
      dynamic.list([
        dynamic.list([
          dynamic.float(1.0),
          dynamic.float(2.1),
        ]),
        dynamic.list([
          dynamic.float(2.2),
          dynamic.float(3.1),
        ]),
        dynamic.list([
          dynamic.float(0.6),
          dynamic.float(4.2),
        ]),
      ]),
      dynamic.list([
        dynamic.list([
          dynamic.float(2.0),
          dynamic.float(3.1),
        ]),
        dynamic.list([
          dynamic.float(3.2),
          dynamic.float(4.1),
        ]),
        dynamic.list([
          dynamic.float(1.6),
          dynamic.float(5.2),
        ]),
      ]),
    ])
  let result = decode.run(data, multipolygon_decoder())
  assert result
    == Ok(
      MultiPolygon([
        Polygon([Point(1.0, 2.1), Point(2.2, 3.1), Point(0.6, 4.2)]),
        Polygon([Point(2.0, 3.1), Point(3.2, 4.1), Point(1.6, 5.2)]),
      ]),
    )
}

// ------------------------------------------------------------------
// feed decoder tests
// ------------------------------------------------------------------
pub fn feed_decoder_test() {
  let feed = json.parse(from: test_data, using: feed_decoder())
  assert feed
    == Ok(
      Feed(
        MultiPolygonGeometry(
          MultiPolygon([
            Polygon([
              Point(-120.719608222098, 48.0938600886194),
              Point(-120.719598093321, 48.0938489542908),
              Point(-120.719608222098, 48.0938600886194),
            ]),
            Polygon([
              Point(-120.719106764279, 48.0947538544272),
              Point(-120.71911360432, 48.0947470376596),
              Point(-120.719115857178, 48.0947663026003),
              Point(-120.719106764279, 48.0947538544272),
            ]),
          ]),
        ),
      ),
    )
}
