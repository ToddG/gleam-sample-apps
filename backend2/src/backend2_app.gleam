import gleam/otp/supervision
import gleam/erlang/atom.{type Atom}
import gleam/erlang/process
import gleam/otp/actor
import logging
import gleam/otp/static_supervisor as sup

// ------------------------------------------------------------------
// Erlang/OTP Application part
// ------------------------------------------------------------------
/// The Erlang/OTP application start.
/// Responsible to start the "top" supervisor process and return its Pid
/// to the application controller.
pub fn start(_app: Atom, _type) -> Result(process.Pid, actor.StartError) {
  logging.log(logging.Info, "Application start - starts the top supervisor")
  case start_supervisor() {
    Ok(actor.Started(pid, _data)) -> {
      logging.log(logging.Info, "supervisor started")
      let sup_name = process.new_name("one_for_all_sup")
      let _ = process.register(pid, sup_name)
      Ok(pid)
    }
    Error(reason) -> {
      logging.log(logging.Info, "supervisor failed")
      Error(reason)
    }
  }
}

/// The Erlang/OTP application stop callback.
/// This is called after all processes in the supervisor tree have
/// been shutdown by the application controller. Responsible for any
/// final clean up actions.
pub fn stop(_state: a) -> Atom {
  atom.create("ok")
}

// -------- Supervisor ----------------------------------
/// Erlang application top supervisor
fn start_simple_actor(){
  fn(){
    actor.new([]) |> actor.start
  }
}

fn start_supervisor() -> Result(actor.Started(sup.Supervisor), actor.StartError) {
  sup.new(sup.OneForAll)
  |> sup.add(supervision.worker(start_simple_actor()))
  |> sup.start
}
