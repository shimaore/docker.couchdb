#!/bin/bash
set -e
NAME=test-001-couchdb

docker kill $NAME 2>/dev/null || true
docker rm $NAME 2>/dev/null || true
docker run -d --net host --name $NAME shimaore/couchdb
sleep 3
curl http://127.0.0.1:5984/
curl http://127.0.0.1:5984/_users
docker kill $NAME
