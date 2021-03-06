#!/bin/bash
set -e
NAME=test-001-couchdb
TAG=`jq -r .version ../package.json`

docker kill $NAME 2>/dev/null || true
docker rm $NAME 2>/dev/null || true
docker run -d -p 127.0.0.1:45984:5984 --name $NAME shimaore/couchdb:$TAG
sleep 3
curl http://127.0.0.1:45984/
curl http://127.0.0.1:45984/_users
docker kill $NAME
docker rm $NAME
