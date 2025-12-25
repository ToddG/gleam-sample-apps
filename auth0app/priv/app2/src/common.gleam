import gleam/dict
import gleam/option.{type Option}

/// The `Msg` type describes all the ways the outside world can talk to our app.
/// That includes user input, network requests, and any other external events.
///

pub type Msg {
  Testing(r: Result(String, String))
  UserClickedIncrement
  UserClickedDecrement
  Auth0PromiseInit(result: Result(String, String))
  Auth0PromiseLoginWithRedirect(result: Result(Bool, String))
  Auth0PromiseHandleRedirectCallback(
    results: Result(dict.Dict(String, String), String),
  )
  Auth0PromiseGetToken(token: Result(TokenPayload, String))
  Auth0PromiseGetUser(user: Result(UserProfile, String))
  Auth0PromiseLogout(result: Result(Bool, String))
}

pub type InitConfig {
  InitConfig(
    domain: String,
    client_id: String,
    redirect_uri: String,
    audience: Option(String),
    scope: Option(String),
  )
}

pub type LoginOptions =
  dict.Dict(String, String)

pub type TokenOptions =
  dict.Dict(String, String)

pub type TokenPayload =
  String

pub type UserProfile {
  UserProfile(
    sub: String,
    name: Option(String),
    email: Option(String),
    picture: Option(String),
  )
}

pub type AppError {
  Auth0Error(s: String)
}
