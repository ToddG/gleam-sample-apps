# backend2

## Development

```sh
gleam run   # Run the project
```

Produces this error (but only if this is set in gleam.toml):

    [erlang]
    application_start_module = "backend2_app"


```
   Compiled in 0.02s
    Running backend2.main
=INFO REPORT==== 11-Nov-2025::13:48:44.182947 ===
    application: backend2
    exited: {bad_return,
                {{backend2_app,start,[normal,[]]},
                 {'EXIT',
                     {undef,
                         [{backend2_app,start,[normal,[]],[]},
                          {application_master,start_it_old,4,
                              [{file,"application_master.erl"},
                               {line,299}]}]}}}}
    type: temporary

=INFO REPORT==== 11-Nov-2025::13:48:44.196629 ===
    application: logging
    exited: stopped
    type: temporary

=INFO REPORT==== 11-Nov-2025::13:48:44.196691 ===
    application: gleeunit
    exited: stopped
    type: temporary

=INFO REPORT==== 11-Nov-2025::13:48:44.196712 ===
    application: gleam_otp
    exited: stopped
    type: temporary

=INFO REPORT==== 11-Nov-2025::13:48:44.196733 ===
    application: gleam_erlang
    exited: stopped
    type: temporary

=INFO REPORT==== 11-Nov-2025::13:48:44.196750 ===
    application: gleam_stdlib
    exited: stopped
    type: temporary

=CRASH REPORT==== 11-Nov-2025::13:48:44.182984 ===
  crasher:
    initial call: application_master:init/3
    pid: <0.84.0>
    registered_name: []
    exception exit: {bad_return,
                        {{backend2_app,start,[normal,[]]},
                         {'EXIT',
                             {undef,
                                 [{backend2_app,start,[normal,[]],[]},
                                  {application_master,start_it_old,4,
                                      [{file,"application_master.erl"},
                                       {line,299}]}]}}}}
      in function  application_master:init/3 (application_master.erl:147)
    ancestors: [application_controller,<0.10.0>]
    message_queue_len: 1
    messages: [{'EXIT',<0.85.0>,normal}]
    links: [<0.45.0>]
    dictionary: []
    trap_exit: true
    status: running
    heap_size: 376
    stack_size: 29
    reductions: 74
  neighbours:

[31;1mruntime error[39m: Erlang error[0m

An Erlang assignment pattern did not match.

unmatched value:
  Error(Backend2(BadReturn(#(Backend2App(Start, [Normal, []]), #(atom.create("EXIT"), Undef([Backend2App(Start, [Normal, []], []), ApplicationMaster(StartItOld, 4, [File(charlist.from_string("application_master.erl")), Line(299)])]))))))

stacktrace:
```

This error was caused by not including the args [here](https://github.com/ToddG/gleam-sample-apps/blob/d6308f6fbe06971c85a142f778d18e37f1834e5d/backend2/src/backend2_app.gleam#L14C1-L14C75).

This resulted in an error at runtime (not compile time):

```rust
pub fn start() -> Result(process.Pid, actor.StartError) {
    ...
}
```

This is the correct form:

```
pub fn start(_app: Atom, _type) -> Result(process.Pid, actor.StartError) {
    ...
}
```
