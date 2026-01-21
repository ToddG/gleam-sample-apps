import formal/form.{type Form}
import gleam/dynamic/decode
import gleam/io
import gleam/json
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import models.{
  type LoginData, type Msg, type User, LoginData, User, UserSubmittedForm,IdPReturned
}
import rsvp
import gleam/http/response.{type Response}

const echo_url = "https://echo.free.beeceptor.com"
// `https://echo.free.beeceptor.com` returns data like this:
//
//{
//  "method": "POST",
//  "protocol": "https",
//  "host": "echo.free.beeceptor.com",
//  "path": "/",
//  "ip": "[2a02:6ea0:d802:6230::19]:45241",
//  "headers": {
//    "Host": "echo.free.beeceptor.com",
//    "User-Agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:146.0) Gecko/20100101 Firefox/146.0",
//    "Content-Length": "47",
//    "Accept": "*/*",
//    "Accept-Encoding": "gzip, deflate, br, zstd",
//    "Accept-Language": "en-US,en;q=0.5",
//    "Content-Type": "application/json",
//    "Dnt": "1",
//    "Origin": "http://localhost:5173",
//    "Priority": "u=0",
//    "Referer": "http://localhost:5173/",
//    "Sec-Fetch-Dest": "empty",
//    "Sec-Fetch-Mode": "cors",
//    "Sec-Fetch-Site": "cross-site",
//    "Sec-Gpc": "1",
//    "Te": "trailers",
//    "Via": "2.0 Caddy"
//  },
//  "parsedQueryParams": {},
//  "parsedBody": {
//    "username": "aaaaaaaaaa",
//    "password": "bbbbbbbb"
//  }
//}

fn encode_post_inputs(data: LoginData) -> json.Json {
  io.println("encode_post, data=" <> string.inspect(data))
  json.object([
    #("username", json.string(data.username)),
    #("password", json.string(data.password)),
  ])
}

fn decode_post_response() {
  use username <- decode.subfield(["parsedBody", "username"], decode.string)
  use password <- decode.subfield(["parsedBody", "password"], decode.string)
  // todo: temporarily return the password from the echo server. in the real thing, we'd return a generated token
  decode.success(User(username:, token: "BUG_BUG_FIXME!!!_" <> password))
}


pub fn idp_auth_response_handler(r: Result(Response(String), rsvp.Error)) -> Msg {
  io.println("idp_auth_response_handler, result=" <> string.inspect(r))
  case r {
    Error(e) -> {
      io.println("rsvp error=" <> string.inspect(e))
      IdPReturned(Error(e))
    }
    Ok(v) -> {
      io.println("rsvp response=" <> string.inspect(v))
      IdPReturned(Ok(User("foo", "bar")))
    }
  }
}

pub fn authenticate_with_idp(
  username: String,
  password: String,
  on_response handle_response: fn(Result(User, rsvp.Error)) -> msg,
) {
  let data = encode_post_inputs(LoginData(username:, password:))
  let handler = rsvp.expect_json(decode_post_response(), handle_response)

  io.println(
    "authenticate_with_idp, username="
    <> username
    <> ", password="
    <> password
    <> ", url="
    <> echo_url
  )
  rsvp.post(echo_url, data, handler)
}

pub fn new_login_form() -> Form(LoginData) {
  // We create an empty form that can later be used to parse, check and decode
  // user supplied data.
  //
  // If the form is to be used with languages other than English then the
  // `form.language` function can be used to supply an alternative error
  // translator.
  form.new({
    use username <- form.field(
      "username",
      form.parse_string
        |> form.check_not_empty
        |> form.check_string_length_less_than(255)
        |> form.check_string_length_more_than(5),
    )

    //    let check_password = fn(password) {
    //      case password == "strawberry" {
    //        True -> Ok(password)
    //        False -> Error("Password must be 'strawberry'")
    //      }
    //    }
    //

    use password <- form.field(
      "password",
      form.parse_string
      |> form.check_not_empty
      |> form.check_string_length_less_than(255)
      |> form.check_string_length_more_than(5),
      //      |> form.check(check_password),
    )
    form.success(LoginData(username:, password:))
  })
}

pub fn display_element(form: Form(LoginData)) -> Element(Msg) {
  // Lustre sends us the form data as a list of tuples, which we can then
  // process, decode, or send off to our backend.
  //
  // Here, we use `formal` to turn the form values we got into Gleam data.
  let handle_submit = fn(values) {
    form |> form.add_values(values) |> form.run |> UserSubmittedForm
  }

  html.form(
    [
      attribute.class("p-8 w-full border rounded-2xl shadow-lg space-y-4"),
      // The message provided to the built-in `on_submit` handler receives the
      // `FormData` associated with the form as a List of (name, value) tuples.
      //
      // The event handler also calls `preventDefault()` on the form, such that
      // Lustre can handle the submission instead off being sent off to the server.
      event.on_submit(handle_submit),
    ],
    [
      html.h1([attribute.class("text-2xl font-medium text-purple-600")], [
        html.text("Sign in"),
      ]),
      //
      view_input(form, is: "text", name: "username", label: "Username"),
      view_input(form, is: "password", name: "password", label: "Password"),
      //
      html.div([attribute.class("flex justify-end")], [
        html.button(
          [
            // buttons inside of forms submit the form by default.
            attribute.class("text-white text-sm font-bold"),
            attribute.class("px-4 py-2 bg-purple-600 rounded-lg"),
            attribute.class("hover:bg-purple-800"),
            attribute.class(
              "focus:outline-2 focus:outline-offset-2 focus:outline-purple-800",
            ),
          ],
          [html.text("Login")],
        ),
      ]),
    ],
  )
}

fn view_input(
  form: Form(LoginData),
  is type_: String,
  name name: String,
  label label: String,
) -> Element(msg) {
  let errors = form.field_error_messages(form, name)

  html.div([], [
    html.label(
      [attribute.for(name), attribute.class("text-xs font-bold text-slate-600")],
      [html.text(label), html.text(": ")],
    ),
    html.input([
      attribute.type_(type_),
      attribute.class(
        "block mt-1 w-full px-3 py-1 border rounded-lg focus:shadow",
      ),
      case errors {
        [] -> attribute.class("focus:outline focus:outline-purple-600")
        _ -> attribute.class("outline outline-red-500")
      },
      // we use the `id` in the associated `for` attribute on the label.
      attribute.id(name),
      // the `name` attribute is used as the first element of the tuple
      // we receive for this input.
      attribute.name(name),
    ]),
    // formal provides us with customisable error messages for every element
    // in case its validation fails, which we can show right below the input.
    ..list.map(errors, fn(error_message) {
      html.p([attribute.class("mt-0.5 text-xs text-red-500")], [
        html.text(error_message),
      ])
    })
  ])
}
