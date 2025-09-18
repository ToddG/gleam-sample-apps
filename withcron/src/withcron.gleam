import clockwork.{type Cron}
import clockwork_schedule
import gleam/erlang/process
import gleam/otp/static_supervisor as supervisor
import logging
import gleam/list


fn create_child_spec(msg: String, cron: Cron){
  let scheduler =
  clockwork_schedule.new("daily_backup" <> msg, cron, fn(){
    logging.log(logging.Info, "backup database!" <> msg)
  })
  |> clockwork_schedule.with_logging()

  // Create a receiver for the schedule handle
  let schedule_receiver = process.new_subject()

  // Create the child specification
  clockwork_schedule.supervised(scheduler, schedule_receiver)
}

pub fn main() {
  let assert Ok(cron) = clockwork.from_string("* * * * *")  // every minute


  //    // EXAMPLE 0 : THIS DOES NOT WORK
  //    // Add to supervision tree
  //    let sup = supervisor.new(supervisor.OneForOne)
  //    ["A", "B", "C"]
  //    |> list.map(fn(x){create_child_spec(x, cron)})
  //    |> list.map(fn(x){supervisor.add(sup, x)})
  //    let _ = supervisor.start(sup)

  //
  //    // EXAMPLE 1 : THIS WORKS!!!
  //    let assert Ok(_sup) =
  //    supervisor.new(supervisor.OneForOne)
  //    |> supervisor.add(create_child_spec("A", cron))
  //    |> supervisor.add(create_child_spec("B", cron))
  //    |> supervisor.add(create_child_spec("C", cron))
  //    |> supervisor.start()


  //    //  EXAMPLE 2 : THIS WORKS!!!
  //    let child_sup =
  //    supervisor.new(supervisor.OneForOne)
  //    |> supervisor.add(create_child_spec("B", cron))
  //    |> supervisor.add(create_child_spec("C", cron))
  //    |> supervisor.supervised
  //
  //    let assert Ok(_sup) =
  //    supervisor.new(supervisor.RestForOne)
  //    |> supervisor.add(create_child_spec("A", cron))
  //    |> supervisor.add(child_sup)
  //    |> supervisor.start()


  // EXAMPLE 3 : THIS WORKS !!!
  // Add to supervision tree
  let _ = ["A", "B", "C"]
  |> list.fold(supervisor.new(supervisor.OneForOne), fn(sup, x){
    supervisor.add(sup, create_child_spec(x, cron))
  })
  |> supervisor.start

  // The scheduler is now running under supervision
  // It will automatically restart if it crashes
  process.sleep_forever()
}