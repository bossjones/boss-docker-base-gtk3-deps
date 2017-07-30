project := boss-docker-base-gtk3-deps
projects := boss-docker-base-gtk3-deps
username := bossjones
container_name := boss-docker-base-gtk3-deps

CONTAINER_VERSION  = $(shell \cat ./VERSION | awk '{print $1}')
GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)

# NOTE: DEFAULT_GOAL
# source: (GNU Make - Other Special Variables) https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
# Sets the default goal to be used if no
# targets were specified on the command
# line (see Arguments to Specify the Goals).
# The .DEFAULT_GOAL variable allows you to
# discover the current default goal,
# restart the default goal selection
# algorithm by clearing its value,
# or to explicitly set the default goal.
# The following example illustrates these cases:
.DEFAULT_GOAL := help

# http://misc.flogisoft.com/bash/tip_colors_and_formatting

RED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
PURP=\033[38;5;129m
GRAY=\033[38;5;246m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE
export PURP
export GRAY

# NOTE: Eg. git symbolic-ref --short HEAD => feature-push-dockerhub
TAG ?= $(CONTAINER_VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

#################################################################################################
# A phony target is one that is not really the name of a file;
# rather it is just a name for a recipe to be executed when you make an explicit request.
# There are two reasons to use a phony target:
# to avoid a conflict with a file of the same name, and to improve performance.

# If you write a rule whose recipe will not create the target file,
# the recipe will be executed every time the target comes up for remaking.
# Here is an example:
# .PHONY: ci test build push-docker-hub
.PHONY: test docker-compose-build docker-compose-up docker-compose-up-build docker-compose-down docker-version docker-exec docker-exec-master rake_deps rake_deps_build rake_deps_build_push docker_build_latest docker_build_compile_jhbuild

default: help
#################################################################################################

# NOTE: Purpose of Makefiles
# By default, Makefile targets are "file targets" -
# they are used to build files from other files.
# Make assumes its target is a file,
# and this makes writing Makefiles relatively easy:

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := name

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

test:
	@docker-compose -f docker-compose.yml -f ci_build.yml up --build

# 4 – Creating Dedicated Data Volume Containers
# source: http://www.tricksofthetrades.net/2016/03/14/docker-data-volumes/
# A popular practice with Docker data sharing is to create a dedicated container that holds all of your persistent shareable data resources,
# mounting the data inside of it into other containers once created and setup.
# This example taken from the Docker documentation uses the postgres SQL training image as a base for the data volume container.
# Note: /bin/true - returns a 0 and does nothing if the command was successful.
create-artifact-volume:
	@docker create -v /jhbuild-artifact --name jhbuild-artifact bossjones/boss-docker-python3:latest /bin/true

create-ccache-volume:
	@docker create -v /jhbuild-ccache --name jhbuild-ccache bossjones/boss-docker-python3:latest /bin/true

create-pip-cache-volume:
	@docker create -v /jhbuild-pip-cache --name jhbuild-pip-cache bossjones/boss-docker-python3:latest /bin/true

docker-compose-build:
	@docker-compose -f docker-compose-devtools.yml build

docker-compose-up:
	@docker-compose -f docker-compose.yml -f ci_build.yml up

docker-compose-up-build:
	@docker-compose -f docker-compose.yml -f ci_build.yml up --build

docker-compose-down:
	@docker-compose -f docker-compose.yml -f ci_build.yml down

docker-version:
	@docker --version
	@docker-compose --version

docker-exec:
	@docker exec -i -t boss-docker-base-gtk3-deps bash

docker-exec-master:
	@docker exec -i -t boss-docker-base-gtk3-deps bash

rake_deps:
	@gem install httparty -v 0.15.5
	@gem install bundler -v 1.15.1
	@bundle install --path .vendor

rake_deps_build: rake_deps
	@bundle exec rake build

rake_deps_build_push: rake_deps_build
	@bundle exec rake push

docker_build_latest:
	@docker build \
	    --build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
	    --build-arg GIT_BRANCH=$(GIT_BRANCH) \
	    --build-arg GIT_SHA=$(GIT_SHA) \
	    --build-arg SCARLETT_ENABLE_SSHD=0 \
	    --build-arg SCARLETT_ENABLE_DBUS='true' \
	    --build-arg SCARLETT_BUILD_GNOME='true' \
	    --build-arg TRAVIS_CI='true' \
		--file=Dockerfile \
	    --tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) .

docker_build_and_tag:
	set -x ;\
	docker build \
	    --build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
	    --build-arg GIT_BRANCH=$(GIT_BRANCH) \
	    --build-arg GIT_SHA=$(GIT_SHA) \
	    --build-arg SCARLETT_ENABLE_SSHD=0 \
	    --build-arg SCARLETT_ENABLE_DBUS='true' \
	    --build-arg SCARLETT_BUILD_GNOME='true' \
	    --build-arg TRAVIS_CI='true' \
		--file=Dockerfile \
	    --tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) . ; \
	docker tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) bossjones/boss-docker-base-gtk3-deps:$(TAG) ; \
	docker tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) bossjones/boss-docker-base-gtk3-deps:latest

docker_build_compile_jhbuild:
	@docker build \
	--build-arg SCARLETT_ENABLE_SSHD=0 \
	--build-arg SCARLETT_ENABLE_DBUS='true' \
	--build-arg SCARLETT_BUILD_GNOME='true' \
	--build-arg TRAVIS_CI='true' \
	-t $(username)/$(container_name)-compile:latest .

version: ## Parse version from ./VERSION
version:
	@echo $(CONTAINER_VERSION)

################################################################################################
#REQUIRED-CI
install-deps:
	@gem install httparty -v 0.15.5
	@gem install bundler -v 1.15.1
	@bundle install --path .vendor

#REQUIRED-CI
resources compile lint test ci : dev-container
	commands/make/run_target_in_container.sh non_docker_$@

#REQUIRED-CI
# NOTE: Idea, do a find for files that should exist after a jhbuild build is finished,
# pass it as RESOURCES, if it isn't there, then this will run
non_docker_resources: $(RESOURCES)
	go-bindata -pkg resources -o resources/bindata.go resources/...

#REQUIRED-CI
non_docker_compile:  install-deps non_docker_resources jhbuild-linux-amd64.tar.gz

non_docker_lint: install-deps
	echo " [non_docker_lint] ok"

#REQUIRED-CI
non_docker_test: install-deps non_docker_lint non_docker_compile
	@echo " [non_docker_test] ******* Checking if test code compiles... *************"

quicktest:
	@echo " [quicktest] ok"

#REQUIRED-CI
non_docker_ci: non_docker_compile non_docker_test

#compile doesn't rebuild unless something changed
#REQUIRED-CI
container: compile
	set -x ;\
	docker build \
	    --build-arg CONTAINER_VERSION=$(CONTAINER_VERSION) \
	    --build-arg GIT_BRANCH=$(GIT_BRANCH) \
	    --build-arg GIT_SHA=$(GIT_SHA) \
	    -e SCARLETT_ENABLE_SSHD=0 \
	    -e SCARLETT_ENABLE_DBUS='true' \
	    -e SCARLETT_BUILD_GNOME='true' \
	    -e TRAVIS_CI='true' \
		--file=Dockerfile.compile.build \
	    --tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) . ; \
	docker tag bossjones/boss-docker-base-gtk3-deps:$(GIT_SHA) bossjones/boss-docker-base-gtk3-deps:$(TAG)

# NOTE: In order to find out, whether their code is running inside a docker environment,
# it was popular to test for the existence of either the /.dockerinit or the /.dockerenv file.
# Since the dockerinit file has been removed in newer versions,
# the best idea should now be to check the existence of the dockerenv file.
dev-container:    ## makes container flotilla:1.7.3-dev and installs go deps
dev-container:
	@if [ ! -e /.dockerenv ]; then \
		echo ; \
		echo ; \
		echo "------------------------------------------------" ; \
		echo "$@: Building dev container image..." ; \
		echo "------------------------------------------------" ; \
		echo ; \
		docker images | grep 'bossjones/boss-docker-base-gtk3-deps' | awk '{print $$2}' | grep -q -E '^dev$$' ; \
		if [ $$? -ne 0 ]; then  \
			docker build -f Dockerfile-dev -t bossjones/boss-docker-base-gtk3-deps:dev . ; \
		fi ; \
	else \
		echo ; \
		echo "------------------------------------------------" ; \
		echo "$@: Running in Docker so skipping..." ; \
		echo "------------------------------------------------" ; \
		echo ; \
		env ; \
		echo ; \
	fi

# NOTE: In order to find out, whether their code is running inside a docker environment,
# it was popular to test for the existence of either the /.dockerinit or the /.dockerenv file.
# Since the dockerinit file has been removed in newer versions,
# the best idea should now be to check the existence of the dockerenv file.
dev-clean:  ## Remove the boss-docker-base-gtk3-deps container image
dev-clean:
	@if [ ! -e /.dockerenv ]; then \
		if $$(docker ps | grep -q "bossjones/boss-docker-base-gtk3-deps:dev"); then \
			echo "You have a running dev container.  Stop it first before using dev-clean" ;\
			exit 10; \
		fi ; \
		docker images | grep 'bossjones/boss-docker-base-gtk3-deps' | awk '{print $$2}' | grep -q -E '^dev$$' ; \
		if [ $$? -eq 0 ]; then  \
			docker rmi bossjones/boss-docker-base-gtk3-deps:dev  ; \
		else \
			echo "No dev image" ;\
		fi ; \
	else \
		echo ; \
		echo "------------------------------------------------" ; \
		echo "$@: Running in Docker so skipping..." ; \
		echo "------------------------------------------------" ; \
		echo ; \
		env ; \
		echo ; \
	fi

################################################################################################

sort-by-size:
	@du -hs * | gsort -h

data-volume-up:
	# set -x; docker create -v $(pwd)/jhbuild_ccache:/ccache --name ccache ubuntu:16.04 /bin/true
	docker volume create --name ccache_jhbuild

data-volume-rm:
	docker volume rm ccache

docker-dev:
	docker-compose -f docker-compose.dev.yml -f ci_build_v2.yml up --build

docker-compile:
	docker-compose -f docker-compose.compile.yml -f ci_build_v2.yml up --build

include commands/make/*.mk
