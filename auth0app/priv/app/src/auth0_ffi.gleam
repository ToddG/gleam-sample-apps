//import common.{type InitConfig, type Msg, Auth0Error}
//import gleam/javascript/promise.{type Promise}
//import gleam/string
//import lustre/effect.{type Effect}
//
//@external(javascript, "./auth0_wrapper.js", "init")
//fn js_init(config: InitConfig) -> Promise(Result(String, String)) {
//  promise.resolve(Error("unkown error, config=" <> string.inspect(config)))
//}
//
////@external(javascript, "./auth0_wrapper.js", "loginWithRedirect")
////fn js_login_with_redirect(opts: Option(LoginOptions)) -> Promise(Bool)
////
////@external(javascript, "./auth0_wrapper.js", "handleRedirectCallback")
////fn js_handle_redirect_callback() -> Promise(dict.Dict(String, String))
////
////@external(javascript, "./auth0_wrapper.js", "getTokenSilently")
////fn js_get_token_silently(opts: Option(TokenOptions)) -> Promise(TokenPayload)
////
////@external(javascript, "./auth0_wrapper.js", "getUser")
////fn js_get_user() -> Promise(Option(UserProfile))
////
////@external(javascript, "./auth0_wrapper.js", "logout")
////fn js_logout(opts: dict.Dict(String, String)) -> Promise(Bool)
//
//pub fn init(config: InitConfig) -> Effect(Msg) {
//  use dispatch <- effect.from
//  let p = js_init(config)
//  promise.await(p, fn(result) { dispatch(common.Auth0PromiseInit(result)) })
//}
