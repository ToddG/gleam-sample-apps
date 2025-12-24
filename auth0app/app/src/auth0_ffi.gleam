import gleam/javascript/promise.{type Promise}

@external(javascript, "./auth0_wrapper.mjs", "init")
pub fn init() -> Promise(Result(String, String))

@external(javascript, "./auth0_wrapper.mjs", "logout")
pub fn logout() -> Promise(Result(String, String))
