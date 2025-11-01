import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/io
import gleam/result

pub fn main() {
  let assert Ok(resp) =
    send_head_request(
      "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Incident_Locations_Last24h/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json",
    )
  echo resp
}

pub fn send_head_request(url: String) {
  io.println("HEAD request : " <> url)
  let assert Ok(req) = request.to(url)

  let req = request.set_method(req, http.Head)
  let config =
    httpc.configure() |> httpc.follow_redirects(True) |> httpc.timeout(4000)
  use resp <- result.try(httpc.dispatch(config, req))
  Ok(resp)
}
