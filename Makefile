release: build tag push

clean:
	@echo Cleaning local Docker image boss-docker-base-gtk3-deps

	docker rm boss-docker-base-gtk3-deps

build: clean
	@echo Building boss-docker-base-gtk3-deps

	docker build -t boss-docker-base-gtk3-deps .

tag:
	@echo Tag local image bossjones/boss-docker-base-gtk3-deps:v1

	docker tag boss-docker-base-gtk3-deps bossjones/boss-docker-base-gtk3-deps:v1

push:
	@echo Pushing bossjones/boss-docker-base-gtk3-deps:v1 to Docker Hub

	docker push docker.io/bossjones/boss-docker-base-gtk3-deps:v1
