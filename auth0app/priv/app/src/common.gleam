//import gleam/dict
//import gleam/option.{type Option}
//
///// The `Msg` type describes all the ways the outside world can talk to our app.
///// That includes user input, network requests, and any other external events.
/////
//pub type Msg {
//  UserClickedIncrement
//  UserClickedDecrement
//  Auth0PromiseInit(result: Result(String, String))
//  //  Auth0PromiseLoginWithRedirect(result: Bool)
//  //  Auth0PromiseHandleRedirectCallback(results: dict.Dict(String, String))
//  //  Auth0PromiseGetToken(token: TokenPayload)
//  //  Auth0PromiseGetUser(user: UserProfile)
//  //  Auth0PromiseLogout(result: Bool)
//}
//
///// Minimal options required to create an Auth0 client.
//pub type InitConfig {
//  InitConfig(
//    domain: String,
//    client_id: String,
//    redirect_uri: String,
//    audience: Option(String),
//    scope: Option(String),
//  )
//}
//
/////// Options passed to loginWithRedirect (can be empty).
////pub type LoginOptions =
////  dict.Dict(String, String)
////
/////// Options passed to getTokenSilently (can be empty).
////pub type TokenOptions =
////  dict.Dict(String, String)
////
/////// The shape of the token payload returned by getTokenSilently.
////pub type TokenPayload =
////  String
////
/////// User profile returned by getUser (or Null if not logged in).
////pub type UserProfile {
////  UserProfile(
////    sub: String,
////    name: Option(String),
////    email: Option(String),
////    picture: Option(String),
////  )
////}
//
//pub type AppError {
//  Auth0Error(s: String)
//}
