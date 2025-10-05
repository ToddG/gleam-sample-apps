# sseexample

## design

### entities

* app: application
* sup: root supervisor
* srp: supervised repeater
* srg: supervised registry
* web: mist webserver
* sse: server side events

### events

* rt: repeater-trigger-heartbeat
* rs: repeater-shutdown
* sh: sse-heartbeat
* ss: sse-shutdown

### structure

    app
        sup
            srp
            srg
            web
                [sse (1 for each http connection), ]

### message flow

    app -> startup -> create sup -> add [srp, srg, web]
    ... time passes ...
    srp -> send [repeater-trigger-heartbeat]
    srp -> receive [repeater-trigger-heartbeat] -> send [sse-heartbeat] to each member of group registry
    sse -> receive [sse-heartbeat] -> send mist event too http connection

## development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## links
* https://github.com/rawhat/mist/blob/master/examples/eventz/src/eventz.gleam
* https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events