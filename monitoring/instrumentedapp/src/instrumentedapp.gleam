import gleam/erlang/process
import gleam/bytes_tree
import gleam/otp/supervision.{type ChildSpecification}
import gleam/otp/static_supervisor as sup
import gleam/dict
import gleam/set
import themis
import themis/counter
import themis/gauge
import themis/histogram
import themis/number
import mist.{type Connection, type ResponseData}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}

pub fn main() {
  // initialize the metrics store
  themis.init()

  // ------------------------------------------------------------------
  // Gauge
  // ------------------------------------------------------------------

  // NOTES:
  // This can fail if the metric name is invalid
  // See discussion [here](https://github.com/guillheu/Themis/issues/5)
  // Summary: 'gauge' is blacklisted for a metric name
  let assert Ok(_) = gauge.new("gge_01", "My first Prometheus 'gauge' metric")

  let labels = dict.from_list([#("foo", "bar")])
  let value = number.integer(10)
  let assert Ok(_) = gauge.observe("gge_01", labels, value)

  // ------------------------------------------------------------------
  // Counter
  // ------------------------------------------------------------------
  // NOTES:
  // This can fail if the metric name is invalid
  // See discussion [here](https://github.com/guillheu/Themis/issues/5)
  // Summary: 'counter' is blacklisted for a metric name
  // Summary: counter metric names must end with '_total'
  let assert Ok(_) =
  counter.new("cntr_01_total", "My first Prometheus 'counter' metric")
  let labels = dict.from_list([#("wibble", "wobble")])
  let other_labels = dict.from_list([#("wii", "woo")])
  let assert Ok(_) =
  counter.new("cntr_02_total", "My second Prometheus 'counter' metric")
  let assert Ok(_) = counter.increment("cntr_02_total", labels)
  let assert Ok(_) =
  counter.increment_by("cntr_02_total", other_labels, number.decimal(1.2))

  // ------------------------------------------------------------------
  // Histogram
  // ------------------------------------------------------------------
  //
  // NOTES:
  // Histograms work with buckets. Each bucket needs an upper boundary.
  // Read more about histograms here https://prometheus.io/docs/practices/histograms/
  // This can fail if the metric name is invalid
  // See discussion [here](https://github.com/guillheu/Themis/issues/5)
  // Summary: 'histogram' is blacklisted for a metric name
  let buckets =
  set.from_list([
  number.decimal(0.05),
  number.decimal(0.1),
  number.decimal(0.25),
  number.decimal(0.5),
  number.integer(1),
  ])
  let assert Ok(_) =
  histogram.new("hgm_01", "My first Prometheus 'histogram' metric", buckets)

  let value = number.integer(20)
  let other_value = number.decimal(1.5)
  let labels = dict.from_list([#("toto", "tata")])
  let other_labels = dict.from_list([#("toto", "titi")])
  let assert Ok(_) =
  histogram.observe("hgm_01", labels, value)
  // When incrementing a histogram with new labels, a new histogram will automatically be initialized
  let assert Ok(_) =
  histogram.observe(
  "hgm_01",
  other_labels,
  other_value,
  )


  // ------------------------------------------------------------------
  // expose metrics on port 2222/
  // ------------------------------------------------------------------
  let _ = sup.new(sup.RestForOne)
  |> sup.add(webserver_child_spec())
  |> sup.start

  process.sleep_forever()
}


pub fn webserver_child_spec( )->ChildSpecification(sup.Supervisor)  {
    fn(req: Request(Connection)) -> Response(ResponseData) {
      case request.path_segments(req) {
        _ ->
        {
          let assert Ok(metrics) = themis.print()
          response.new(200)
          |> response.set_body(mist.Bytes(bytes_tree.from_string(metrics)))
        }
      }
    }
    |> mist.new
    |> mist.bind("0.0.0.0")
    |> mist.with_ipv6
    |> mist.port(2020)
    |> mist.supervised
}
