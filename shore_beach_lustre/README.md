# shore_beach_lustre

## Development

### create client/server key for ssh

```sh
# this is only needed once
ssh-keygen -t ed25519 -f ssh_host_ed25519_key -N ''
```

### run the server

```sh
gleam run
```

### connect to the server over ssh

```sh
ssh localhost -p 2222
```

### connect to the server over http
todo