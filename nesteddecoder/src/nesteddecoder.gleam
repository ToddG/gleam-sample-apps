import gleam/dynamic/decode.{type Decoder}
import gleam/io

pub fn main() -> Nil {
  io.println("Hello from nesteddecoder!")
}

pub type Point {
  Point(lat: Float, lng: Float)
}

pub type Polygon {
  Polygon(points: List(Point))
}

pub type MultiPolygon {
  MultiPolygon(polygons: List(Polygon))
}

pub type Geometry {
  PointGeometry(point: Point)
  PolygonGeometry(polygon: Polygon)
  MultiPolygonGeometry(multipolygon: MultiPolygon)
}

pub type Feed {
  Feed(geometry: Geometry)
}

pub fn point_decoder() -> Decoder(Point) {
  use floats <- decode.then(decode.list(decode.float))
  case floats {
    [lat, lng] -> decode.success(Point(lat:, lng:))
    _ -> decode.failure(Point(lat: 0.0, lng: 0.0), "Point")
  }
}

pub fn polygon_decoder() -> decode.Decoder(Polygon) {
  use points <- decode.then(decode.list(of: point_decoder()))
  decode.success(Polygon(points:))
}

pub fn multipolygon_decoder() -> decode.Decoder(MultiPolygon) {
  use polygons <- decode.then(decode.list(of: polygon_decoder()))
  decode.success(MultiPolygon(polygons:))
}

pub fn feed_decoder() -> decode.Decoder(Feed) {
  use multipolygon <- decode.subfield(
    ["geometry", "rings"],
    multipolygon_decoder(),
  )
  decode.success(Feed(MultiPolygonGeometry(multipolygon:)))
}
