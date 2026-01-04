# xtermjs

## Log

```
mkdir -p priv/webapp
cd priv/webapp
pnpm create vite

tree -L 2

priv/webapp/myconsole/
├── index.html
├── node_modules
│   └── vite -> .pnpm/vite@7.3.0/node_modules/vite
├── package.json
├── pnpm-lock.yaml
├── public
│   └── vite.svg
└── src
    ├── counter.js
    ├── javascript.svg
    ├── main.js
    └── style.css
```

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
