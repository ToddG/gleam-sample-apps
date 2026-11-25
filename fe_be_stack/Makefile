all: init

.PHONY:freebsd_init
freebsd_init:
	sudo pkg install www/npm-node26
	sudo npm config set allow-scripts=pnpm --location=user
	sudo npm upgrade npm
	sudo npm i -g pnpm


.PHONY:build
build:
	cd ./frontend && $(MAKE) build
	cd ./backend/be_app_name && $(MAKE) build

.PHONY:run
run:
	/bin/sh ./helper.sh

