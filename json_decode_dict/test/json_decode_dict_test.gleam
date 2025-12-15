import geocodio_decoders
import gleam/dict
import gleam/json
import gleam/list
import gleam/string
import logging
import startest.{describe, it}
import startest/expect

//# Using q parameter curl
//"https://api.geocod.io/v1.9/geocode?q=1109+N+Highland+St%2c+Arlington+VA&api_key=YOUR_API_KEY"
//
//# Using individual address components
//curl "https://api.geocod.io/v1.9/geocode?street=1109+N+Highland+St&city=Arlington&state=VA&api_key=YOUR_API_KEY"

pub const geocodio_result = "
{
  \"input\": {
    \"address_components\": {
      \"number\": \"1109\",
      \"predirectional\": \"N\",
      \"street\": \"Highland\",
      \"suffix\": \"St\",
      \"formatted_street\": \"N Highland St\",
      \"city\": \"Arlington\",
      \"state\": \"VA\",
      \"zip\": \"22201\",
      \"country\": \"US\"
    },
    \"formatted_address\": \"1109 N Highland St, Arlington, VA 22201\"
  },
  \"results\": [
    {
      \"address_components\": {
        \"number\": \"1109\",
        \"predirectional\": \"N\",
        \"street\": \"Highland\",
        \"suffix\": \"St\",
        \"formatted_street\": \"N Highland St\",
        \"city\": \"Arlington\",
        \"county\": \"Arlington County\",
        \"state\": \"VA\",
        \"zip\": \"22201\",
        \"country\": \"US\"
      },
      \"address_lines\": [
        \"1109 N Highland St\",
        \"\",
        \"Arlington, VA 22201\"
      ],
      \"formatted_address\": \"1109 N Highland St, Arlington, VA 22201\",
      \"location\": {
        \"lat\": 38.886665,
        \"lng\": -77.094733
      },
      \"accuracy\": 1,
      \"accuracy_type\": \"rooftop\",
      \"source\": \"Virginia GIS Clearinghouse\"
    }
  ]
}
"


pub const geocodio_batch_result = "
{
  \"results\": {
    \"FID1\": {
      \"query\": \"1109 N Highland St, Arlington VA\",
      \"response\": {
        \"input\": {
          \"address_components\": {
            \"number\": \"1109\",
            \"predirectional\": \"N\",
            \"street\": \"Highland\",
            \"suffix\": \"St\",
            \"formatted_street\": \"N Highland St\",
            \"city\": \"Arlington\",
            \"state\": \"VA\",
            \"zip\": \"22201\",
            \"country\": \"US\"
          },
          \"formatted_address\": \"1109 N Highland St, Arlington, VA\"
        },
        \"results\": [
          {
            \"address_components\": {
              \"number\": \"1109\",
              \"predirectional\": \"N\",
              \"street\": \"Highland\",
              \"suffix\": \"St\",
              \"formatted_street\": \"N Highland St\",
              \"city\": \"Arlington\",
              \"county\": \"Arlington County\",
              \"state\": \"VA\",
              \"zip\": \"22201\",
              \"country\": \"US\"
            },
            \"address_lines\": [
              \"1109 N Highland St\",
              \"\",
              \"Arlington, VA 22201\"
            ],
            \"formatted_address\": \"1109 N Highland St, Arlington, VA 22201\",
            \"location\": {
              \"lat\": 38.886672,
              \"lng\": -77.094735
            },
            \"accuracy\": 1,
            \"accuracy_type\": \"rooftop\",
            \"source\": \"Arlington\"
          }
        ]
      }
    }
  }
}
"

pub const geocodio_batch_bad_result = "
{
  \"results\": {
    \"FID1\": {
      \"query\": \"1109 N Highland St, Arlington VA\",
      \"response\": {
        \"input\": {
          \"address_components\": {
            \"number\": \"1109\",
            \"predirectional\": \"N\",
            \"street\": \"Highland\",
            \"suffix\": \"St\",
            \"formatted_street\": \"N Highland St\",
            \"city\": \"Arlington\",
            \"state\": \"VA\",
            \"country\": \"US\"
          },
          \"formatted_address\": \"1109 N Highland St, Arlington, VA\"
        },
        \"results\": [
          {
            \"address_components\": {
              \"number\": \"1109\",
              \"predirectional\": \"N\",
              \"street\": \"Highland\",
              \"suffix\": \"St\",
              \"formatted_street\": \"N Highland St\",
              \"city\": \"Arlington\",
              \"county\": \"Arlington County\",
              \"state\": \"VA\",
              \"zip\": \"22201\",
              \"country\": \"US\"
            },
            \"address_lines\": [
              \"1109 N Highland St\",
              \"\",
              \"Arlington, VA 22201\"
            ],
            \"formatted_address\": \"1109 N Highland St, Arlington, VA 22201\",
            \"location\": {
              \"lat\": 38.886672,
              \"lng\": -77.094735
            },
            \"accuracy\": 1,
            \"accuracy_type\": \"rooftop\",
            \"source\": \"Arlington\"
          }
        ]
      }
    }
  }
}
"

pub const location_json = "
{
  \"lat\": 38.886672,
  \"lng\": -77.094735
}
"

// ------------------------------------------------------------------
// startest
// ------------------------------------------------------------------
pub fn main() -> Nil {
  logging.configure()
  startest.run(startest.default_config())
}

pub fn geocodio_decoder_tests() {
  describe("geocodio decode", [
    describe("element decoders", [
      describe("location", [
        it("lat / lng", fn() {
          case
            json.parse(
              from: location_json,
              using: geocodio_decoders.location_decoder(),
            )
          {
            Ok(location) -> {
              location.lat |> expect.to_equal(38.886672)
              location.lng |> expect.to_equal(-77.094735)
            }
            Error(e) -> string.inspect(e) |> expect.to_equal("")
          }
        }),
      ]),
    ]),
    describe("single", [
      describe("request", [
        it("street=1109+n+highland+st&city=arlington&state=va", fn() {
          case
            json.parse(
              from: geocodio_result,
              using: geocodio_decoders.single_response_decoder(),
            )
          {
            Ok(single_result) -> {
              single_result.input.address_components.number
              |> expect.to_equal("1109")
              let assert Ok(x) = list.first(single_result.results)
              x.source |> expect.to_equal("Virginia GIS Clearinghouse")
            }
            Error(e) -> string.inspect(e) |> expect.to_equal("")
          }
        }),
      ]),
    ]),
    describe("batch", [
      describe("request", [
        it("1109 N Highland St, Arlington VA", fn() {
          case
            json.parse(
              from: geocodio_batch_result,
              using: geocodio_decoders.batch_response_decoder(),
            )
          {
            Ok(batch_results) -> {
              let r = batch_results.results
              dict.has_key(r, "FID1") |> expect.to_equal(True)
              case dict.get(r, "FID1") {
                Ok(bv) -> {
                  bv.query
                  |> expect.to_equal("1109 N Highland St, Arlington VA")
                  bv.response.input.address_components.number
                  |> expect.to_equal("1109")
                  case list.first(bv.response.results) {
                    Ok(first) -> first.source |> expect.to_equal("Arlington")
                    Error(e) -> string.inspect(e) |> expect.to_equal("")
                  }
                }
                Error(e) -> string.inspect(e) |> expect.to_equal("")
              }
            }
            Error(e) -> string.inspect(e) |> expect.to_equal("")
          }
        }),
      ]),
    ]),
    describe("batch", [
      describe("bad request", [
        it("missing zip: 1109 N Highland St, Arlington VA", fn() {
            json.parse(
              from: geocodio_batch_bad_result,
              using: geocodio_decoders.batch_response_decoder(),
            ) |> expect.to_be_error()
          Nil
        }),
      ]),
    ]),
  ])
}
