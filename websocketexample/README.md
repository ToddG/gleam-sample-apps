# websocketexample

## design

### entities

* app: application
* sup: root supervisor
* srp: supervised repeater
* srg: supervised registry
* web: mist webserver
* wse: websocket events 

### events

* rt: repeater-trigger-heartbeat
* rs: repeater-shutdown
* wh: ws-heartbeat
* ws: ws-shutdown

### structure

    app
        sup
            srp
            srg
            web
                [wse (1 for each http connection), ]

### message flow

    app -> startup -> create sup -> add [srp, srg, web]
    ... time passes ...
    srp -> send [repeater-trigger-heartbeat]
    srp -> receive [repeater-trigger-heartbeat] -> send [wse-heartbeat] to each member of group registry
    wse -> receive [wse-heartbeat] -> send data to conn over opene websocket

## development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
