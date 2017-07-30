export DOCKER_IP = $(shell ifconfig en0 | grep "inet "  | cut -d" " -f2)

check-docker-env-vars:
	@echo "DOCKER_HOST = \"$$DOCKER_HOST\""; \
	echo "DOCKER_IP = \"$$DOCKER_IP\""; \
	if [ -z "$$DOCKER_IP" ]; then \
		echo "DOCKER_IP is not set. Check your docker-machine is running or do \"eval \$$(docker-machine env)\"?" 1>&2; \
		exit 1; \
	fi; \
	if [ "$$DOCKER_IP" = "127.0.0.1" ]; then \
		echo "DOCKER_IP is set to a loopback address. Check your docker-machine is running or do \"eval \$$(docker-machine env)\"?" 1>&2; \
		exit 1; \
	fi

dev-up: check-docker-env-vars
	# docker-compose up -d
	docker-compose -f docker-compose.test.yml -f ci_build.yml up --build

dev-down: check-docker-env-vars
	docker-compose -f docker-compose.test.yml -f ci_build.yml stop
	docker-compose -f docker-compose.test.yml -f ci_build.yml rm -f

# bash-up: check-docker-env-vars
# 	docker-compose up -d fd

# bash-down: check-docker-env-vars
# 	docker-compose stop fd
