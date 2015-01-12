NAME=shimaore/couchdb
TAG=1.6.1

image:
	docker build -t ${NAME} .
	docker build -t ${NAME}:${TAG} .

image-no-cache:
	docker build --no-cache -t ${NAME} .
	docker build -t ${NAME}:${TAG} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${NAME}:${TAG}
	docker push ${NAME}
