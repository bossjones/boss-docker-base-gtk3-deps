define ASCIIGTKDEPS
 _                                        _    _               _
( )                                      ( )_ ( )             ( )
| |_      _ _   ___    __   ______   __  | ,_)| |/')______   _| |   __   _ _     ___
| '_`\  /'_` )/',__) /'__`\(______)/'_ `\| |  | , <(______)/'_` | /'__`\( '_`\ /',__)
| |_) )( (_| |\__, \(  ___/       ( (_) || |_ | |\`\      ( (_| |(  ___/| (_) )\__, \
(_,__/'`\__,_)(____/`\____)       `\__  |`\__)(_) (_)     `\__,_)`\____)| ,__/'(____/
                                  ( )_) |                               | |
                                   \___/'                               (_)

============boss-docker-base-gtk3-deps============
endef

export ASCIIGTKDEPS

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

help:
	@printf "\033[1m$$ASCIIGTKDEPS $$NC\n"
	@printf "\033[21m\n"
	@printf "Environment Variables:\n\n"
	@printf "You need environment variables as per the docs, export these using direnv.\n"
	@printf "Basic samples are available in .envrc.sample\n"
	@printf "\n"
	@printf "=======================================\n"
	@printf "\n"
	@printf "Publish Commands:\n"
	@printf "$$BLUE make push-artifactory$$NC             Runs \"container\", pushes image to Artifactory, tagged by version (make version)\n"
	@printf "$$BLUE make push-docker-hub$$NC              $$RED(CI)$$NC Runs \"container\", pushes image to Docker Hub, tagged based on GIT_SHA (also used by CI)\n"
	@printf "$$BLUE make container$$NC                    $$RED(CI)$$NC Runs release Docker build, tags image with SHA, and tags with TAG value (see below)\n"
	@printf "$$BLUE make version$$NC                      $$RED(CI)$$NC Pulls version from VERSION to stdout, extension for future CI Push use\n"
	@printf "$$BLUE make build$$NC                        $$RED(CI)$$GRAY (deprecated)$$NC Proxies to push-docker-hub, used by CI pipeline\n"
	@printf "\n"
	@printf "Docker Build Targets (all call dev-container by default):\n"
	@printf "$$PURP make compile$$NC                      $$RED(CI)$$NC Calls install-deps, resources, jhbuild-linux-amd64.tar.gz\n"
	@printf "$$PURP make lint$$NC                         Runs goss.lint test inside running container\n"
	@printf "$$PURP make test$$NC                         $$RED(CI)$$NC Compile and runs unit tests using goss test\n"
	@printf "$$PURP make ci$$NC                           $$RED(CI)$$NC Run by external CI pipeline, calls compile and test\n"
	@printf "\n"
	@printf "Non-Docker Build Targets:\n"
	@printf "  $$GRAY NB: non_docker_X is deprecated, all local dev work should be done in Docker using run_target_in_container.sh$$NC\n"
	@printf "$$ORNG make dev-container$$NC                Docker builds a dev container image based on Dockerfile-dev for local development\n"
	@printf "$$ORNG make dev-clean$$NC                    Removes dev container from local images, you must stop it first\n"
	@printf "$$ORNG make install-deps$$NC                 $$RED(CI)$$NC Runs glide install to install dependent packages for a given context\n"
	@printf "$$ORNG make jhbuild-linux-amd64.tar.gz$$NC  $$RED(CI)$$NC Runs jhbuild build on codebase to compile binaries for a given context\n"
	@printf "$$ORNG make non_docker_compile$$NC           $$GRAY(deprecated)$$NC Calls install-deps, non_docker_resources, jhbuild-linux-amd64.tar.gz\n"
	@printf "$$ORNG make non_docker_lint$$NC              $$GRAY(deprecated)$$NC Runs goss.lint outside of container\n"
	@printf "$$ORNG make non_docker_test$$NC              $$GRAY(deprecated)$$NC Runs goss test outside container\n"
	@printf "$$ORNG make non_docker_ci$$NC                $$GRAY(deprecated)$$NC Runs non_docker_compile and non_docker_test outside container\n"
	@printf "\n"
	@printf "Dev Tool Commands:\n"
	@printf "$$GREEN make install-tools$$NC                Installs necessary tools for development using which\n"
	@printf "$$GREEN make check-docker-env-vars$$NC        Checks for common errors with your DOCKER_HOST and DOCKER_IP env variables\n"
	@printf "$$GREEN make dev-up$$NC                       docker-compose up -d for all boss-docker-base-gtk3-deps supporting services\n"
	@printf "$$GREEN make dev-down$$NC                     docker-compose stop/rm all boss-docker-base-gtk3-deps supporting services\n"
	@printf "$$GREEN make bash-up$$NC                        docker-compose up -d for only FD container\n"
	@printf "$$GREEN make bash-down$$NC                      docker-compose stop for only FD container\n"
	@printf "\n"
	@printf "=======================================\n"
	@printf "\"make container\" target image tagging:\n"
	@printf "$$GRAY\n"
	@printf "We default to building an pushing a Docker image with a tag of "latest",because this is what CI needs.\n"
	@printf "However, a developer can locally set it to a value.\n"
	@printf "If they set it to the special value "@branch", then it gets set to the name of their git branch. E.g.:\n"
	@printf "\n"
	@printf "$ make container\n"
	@printf "  ... docker tag bossjones/boss-docker-base-gtk3-deps:\$$sha bossjones/boss-docker-base-gtk3-deps:latest\n"
	@printf "\n"
	@printf "$ make TAG=foo container\n"
	@printf "  ... docker tag bossjones/boss-docker-base-gtk3-deps:\$$sha bossjones/boss-docker-base-gtk3-deps:foo\n"
	@printf "\n"
	@printf "$ make TAG=@branch container\n"
	@printf "  ... docker tag bossjones/boss-docker-base-gtk3-deps:\$$sha bossjones/boss-docker-base-gtk3-deps:customize_image_tag\n"
	@printf "$$NC\n"
