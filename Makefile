#
# Makefile
#

PROJECT_DIR		:= $(PWD)

.PHONY: setup update test build lint cibuild

setup:
	$(PROJECT_DIR)/script/setup

update:
	$(PROJECT_DIR)/script/update

test:
	$(PROJECT_DIR)/script/test

build:
	$(PROJECT_DIR)/script/build

lint:
	$(PROJECT_DIR)/script/lint

FL_LANE?="ci_build"
FL_ENV?="default"

cibuild:
	$(PROJECT_DIR)/script/cibuild $(FL_LANE) $(FL_ENV)
