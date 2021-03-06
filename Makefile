NAME=shimaore/couchdb
TAG=`jq -r .version package.json`
DEBIAN_VERSION=`jq -r .debian.version package.json`

image: Dockerfile
	docker build -t ${NAME}:${TAG} .
	docker tag -f ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}

%: %.src
	sed -e "s/DEBIAN_VERSION/${DEBIAN_VERSION}/" $< >$@

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${NAME}:${TAG}
