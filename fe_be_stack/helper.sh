#!/bin/sh
#
cd ./frontend && pnpm dev &
pid_frontend=$!

echo "1234" > /tmp/gleam_secret_key_file
cd ./backend/be_app_name && BE_APP_WEBSERVER_PORT=5000 BE_APP_LOG_LEVEL=info BE_APP_SECRET_KEY_FILE=/tmp/gleam_secret_key_file gleam run &
pid_backend=$!

cleanup() {
  echo "cleanup killing $pid_frontend $pid_backend ..."
  kill "$pid_frontend" "$pid_backend" 2>/dev/null
  wait
}
trap cleanup EXIT INT TERM

wait
