import gleam/dict

// ------------------------------------------------------------------
// geocodio types
// ------------------------------------------------------------------

pub type AddressComponents {
  AddressComponents(
    number: String,
    predirectional: String,
    street: String,
    suffix: String,
    formatted_street: String,
    city: String,
    state: String,
    zip: String,
    country: String,
  )
}

pub type Input {
  Input(address_components: AddressComponents, formatted_address: String)
}

pub type Location {
  Location(lat: Float, lng: Float)
}

pub type Result {
  Result(
    address_components: AddressComponents,
    address_lines: List(String),
    formatted_address: String,
    location: Location,
    accuracy: Int,
    accuracy_type: String,
    source: String,
  )
}

// ------------------------------------------------------------------
// single results
// ------------------------------------------------------------------

pub type SingleResult {
  SingleResult(input: Input, results: List(Result))
}

// ------------------------------------------------------------------
// batch results
// ------------------------------------------------------------------

pub type BatchResponse {
  BatchResponse(input: Input, results: List(Result))
}


pub type BatchValue {
  BatchValue(query: String, response: BatchResponse)
}

pub type BatchResults {
  BatchResults(results: dict.Dict(String, BatchValue))
}
