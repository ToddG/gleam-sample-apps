import gleam/io
import gleam/erlang/process
import logging
import beach_service
import lustre_service

pub fn main() {
  logging.configure()
  io.println("Hello from shore_beach_lustre!")
  beach_service.start_beach()
  lustre_service.start_webapp()
  process.sleep_forever()
}

