# httprequest

## Development

```sh
gleam run   # Run the project
```
curl -I takes           00.7 s
gleam_httpc takes       30.6 s

```sh

✘-127 ~/repos/personal/gleam/gleam-sample-apps/httprequest [toddg/httprequest|✔]
15:11 $ time curl -I "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Incident_Locations_Last24h/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
HTTP/2 200
date: Sat, 01 Nov 2025 22:11:37 GMT
content-type: application/json; charset=utf-8
content-length: 95083
cache-control: public, max-age=300, s-maxage=300
last-modified: Sat, 01 Nov 2025 22:07:09 GMT
etag: sd274873_145042275
vary: X-Esri-Authorization
request-context: appId=cid-v1:fd6e1bc1-25b9-4c44-b84e-cad200af25b3
request-context: appId=cid-v1:76c62117-7333-4258-8b6f-ed44d6def619
x-arcgis-upstream: us1h03c00
strict-transport-security: max-age=63072000
x-arcgis-trace-id: 20251101T221105Z-159f457d9fc2w8jvhC1CO1vxu00000000cu0000000000xrb
x-esri-query-request-units: 2
x-esri-tiles-basic-query-mode: true
x-esri-tiles-basic-query-type: Basic
x-esri-org-request-units-per-min: usage=375;max=115200
x-esri-query-geometry-field-name: Shape
x-arcgis-correlation-id: 6ab2d6bdc1160167
x-arcgis-instance: 2hyjso3px000000
access-control-expose-headers: Request-Context
access-control-allow-origin: *
access-control-allow-headers: Content-Type, Authorization, X-Esri-Authorization
access-control-allow-credentials: true
x-azure-ref: 20251101T221137Z-1759895c94bdrrpvhC1CO181yw0000000ck0000000007zhh
x-fd-int-roxy-purgeid: 0
x-cache-info: L2_T2
x-cache: TCP_REMOTE_HIT
accept-ranges: bytes


real    0m0.709s
user    0m0.023s
sys     0m0.010s
✔ ~/repos/personal/gleam/gleam-sample-apps/httprequest [toddg/httprequest|✔]
15:11 $ time gleam run
  Compiling httprequest
warning: Unused private constant
  ┌─ /media/toddg/data1/repos/personal/gleam/gleam-sample-apps/httprequest/src/httprequest.gleam:9:1
  │
9 │ const url = "https://test-api.service.hmrc.gov.uk/hello/world"
  │ ^^^^^^^^^ This private constant is never used

Hint: You can safely remove it.

   Compiled in 0.36s
    Running httprequest.main
Hello from httprequest!
HEAD request : https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Incident_Locations_Last24h/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json
Error(ResponseTimeout)

real    0m30.680s
user    0m4.294s
sys     0m0.606s```
