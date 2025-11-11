import gleam/erlang/process
import logging

pub fn main() -> Nil {
  logging.configure()
  logging.set_level(logging.Debug)
  logging.log(logging.Debug, "backend server starting...")
  observer_start()
  process.sleep_forever()
}

type ErlangResult

@external(erlang, "observer", "start")
fn observer_start() -> ErlangResult

/// Sets the so called process label for unregistered processes
/// to aid in debugging.
/// See [proc_lib:set_label/1](https://www.erlang.org/docs/28/apps/stdlib/proc_lib.html#set_label/1)
@external(erlang, "proc_lib", "set_label")
pub fn set_label(l: String) -> SetLabelResult

pub type SetLabelResult
