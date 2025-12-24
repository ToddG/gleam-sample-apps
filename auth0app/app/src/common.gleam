pub type Msg {
  UserClickedIncrement
  UserClickedDecrement
  UserClickedLogout
  Auth0PromiseInit(result: Result(String, String))
  Auth0PromiseLogout(result: Result(String, String))
}
