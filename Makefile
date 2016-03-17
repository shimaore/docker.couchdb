NAME=`jq -r .docker_name package.json`
TAG=`jq -r .version package.json`
DEBIAN_VERSION=`jq -r .debian.version package.json`
COUCHDB_COMMIT=`jq -r .couchdb.commit package.json`

image: Dockerfile
	docker build -t ${NAME}:${TAG} .
	docker tag -f ${NAME}:${TAG} ${REGISTRY}/${NAME}:${TAG}

%: %.src
	sed -e "s/DEBIAN_VERSION/${DEBIAN_VERSION}/" $< >$@
	sed -e "s/COUCHDB_COMMIT/${COUCHDB_COMMIT}/" $< >$@

tests:
	cd test && for t in ./*.sh; do $$t; done

push: image tests
	docker push ${REGISTRY}/${NAME}:${TAG}
	docker push ${NAME}:${TAG}
