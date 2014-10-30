NAME=shimaore/couchdb

image:
	docker build -t ${NAME} .

image-no-cache:
	docker build --no-cache -t ${NAME} .

push: image
	docker push ${NAME}
