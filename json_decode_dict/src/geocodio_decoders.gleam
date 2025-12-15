import gleam/dynamic/decode.{type Decoder}
import geocodio_schema.{
  type AddressComponents, type BatchResponse, type BatchResults, type BatchValue,
  type Input, type Location, type Result, type SingleResult, AddressComponents,
  BatchResponse, BatchResults, BatchValue, Input, Location, Result, SingleResult,
}

// ------------------------------------------------------------------
// geocodio decoders
// ------------------------------------------------------------------

pub fn results_decoder() -> Decoder(List(Result)) {
  decode.list(result_decoder())
}

pub fn location_decoder() -> Decoder(Location) {
  use lat <- decode.field("lat", decode.float)
  use lng <- decode.field("lng", decode.float)
  decode.success(Location(lat, lng))
}

pub fn result_decoder() -> Decoder(Result) {
  use address_components <- decode.field(
    "address_components",
    address_components_decoder(),
  )
  use address_lines <- decode.field("address_lines", decode.list(decode.string))
  use formatted_address <- decode.field("formatted_address", decode.string)
  use location <- decode.field("location", location_decoder())
  use accuracy <- decode.field("accuracy", decode.int)
  use accuracy_type <- decode.field("accuracy_type", decode.string)
  use source <- decode.field("source", decode.string)

  decode.success(Result(
    address_components,
    address_lines,
    formatted_address,
    location,
    accuracy,
    accuracy_type,
    source,
  ))
}

pub fn address_components_decoder() -> Decoder(AddressComponents) {
  use number <- decode.field("number", decode.string)
  use predirectional <- decode.field("predirectional", decode.string)
  use street <- decode.field("street", decode.string)
  use suffix <- decode.field("suffix", decode.string)
  use formatted_street <- decode.field("formatted_street", decode.string)
  use city <- decode.field("city", decode.string)
  use state <- decode.field("state", decode.string)
  use zip <- decode.field("zip", decode.string)
  use country <- decode.field("country", decode.string)

  decode.success(AddressComponents(
    number,
    predirectional,
    street,
    suffix,
    formatted_street,
    city,
    state,
    zip,
    country,
  ))
}

pub fn input_decoder() -> Decoder(Input) {
  use address_components <- decode.field(
    "address_components",
    address_components_decoder(),
  )
  use formatted_address <- decode.field("formatted_address", decode.string)
  decode.success(Input(address_components, formatted_address))
}

pub fn single_response_decoder() -> Decoder(SingleResult) {
  use input <- decode.field("input", input_decoder())
  use results <- decode.field("results", results_decoder())
  decode.success(SingleResult(input, results))
}

// ------------------------------------------------------------------
// batch
// ------------------------------------------------------------------
pub fn batch_single_response_decoder() -> Decoder(BatchResponse) {
  use input <- decode.field("input", input_decoder())
  use results <- decode.field("results", results_decoder())
  decode.success(BatchResponse(input, results))
}

pub fn batch_value_decoder() -> Decoder(BatchValue) {
  use query <- decode.field("query", decode.string)
  use response <- decode.field("response", batch_single_response_decoder())
  decode.success(BatchValue(query, response))
}

pub fn batch_response_decoder() -> Decoder(BatchResults) {
  use results <- decode.field(
    "results",
    decode.dict(decode.string, batch_value_decoder()),
  )
  decode.success(BatchResults(results))
}
