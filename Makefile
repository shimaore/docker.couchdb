NAME := $(shell jq -r .docker_name package.json)
TAG := $(shell jq -r .version package.json)

image: Dockerfile
	docker build -t ${NAME}:${TAG} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${NAME}:${TAG}
