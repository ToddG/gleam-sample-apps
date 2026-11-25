all: clean check format test build package publish

APPNAME := be_app_name
# TODO why are the erlang binaries so specific?
DEPS := gleam erlang-runtime28 erlang rebar3

.PHONY:init
init:
	sudo zfs create -o canmount=off -o mountpoint=/opt zroot/opt
	sudo zfs create zroot/opt/builds
	sudo chown -R toddg:toddg /opt
	zfs list


.PHONY:clean
clean:
	rm -rf ./build
	rm -rf ./tmp

.PHONY:test
test:
	gleam test

.PHONY:check
check:
	gleam check

.PHONY:format
format:
	gleam format

.PHONY:run
run:
	echo "1234" > /tmp/gleam_secret_key_file
	BE_APP_WEBSERVER_PORT=5000 BE_APP_LOG_LEVEL=info BE_APP_SECRET_KEY_FILE=/tmp/gleam_secret_key_file gleam run

.PHONY:build
build:
	gleam build
	gleam export erlang-shipment

.PHONY:package
package:
	glm_freebsd_package

.PHONY:publish
publish:
	cp ./packages/$(APPNAME)-*.pkg /opt/builds
	sudo pkg fetch -y -d -o /opt/builds $(DEPS)
