NAME=shimaore/couchdb
TAG=`jq -r .version package.json`

image:
	docker build -t ${NAME}:${TAG} .

image-no-cache:
	docker build -t ${NAME}:${TAG} .

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${NAME}:${TAG}
