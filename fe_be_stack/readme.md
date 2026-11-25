# frontend & backend example stack

* frontend : react
* backend : gleam


## quickstart

### build and launch

```bash
make build
make run
```

### start an ssh tunnel

If your are running all this on an OS with a GUI/WindowManager and a web browser, then ignore these steps.

If you are running all this within a headless vm (e.g. no GUI/WindowManager) then you'll want to expose port 3000
to your host OS (which presumably is not headless)...

```bash
ssh 3000:localhost:3000 [name of vm running this app stack]
```

Navigate to localhost:3000 to open the react web app.


## Notes:

* Disable or reconfigure the Auth0 stuff as nec
