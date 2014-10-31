#!/bin/bash
set -e

docker kill test-001-couchdb || true
docker run -d --net host --name test-001-couchdb shimaore/couchdb
sleep 3
curl http://127.0.0.1:5984/
curl http://127.0.0.1:5984/_users
docker kill test-001-couchdb
