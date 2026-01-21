import formal/form.{type Form}
import gleam/option.{type Option}

pub type Model {
  Model(route: Route, user: Option(User), errors: Option(Form(LoginData)))
}

pub type User {
  User(name: String)
}

pub type Route {
  Wibble
  Wobble
  Login
  LoggedIn
}

pub type Msg {
  OnRouteChange(Route)
  UserSubmittedForm(Result(LoginData, Form(LoginData)))
}

pub type LoginData {
  LoginData(username: String, password: String)
}
