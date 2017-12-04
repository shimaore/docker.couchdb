#!/bin/bash
docker run -d -p 5984:5984 -v $(pwd):/opt/couchdb/data klaemo/couchdb

# GET /_cluster_setup returns:
#   {"state":"cluster_disabled"}
# GET /_membership
#   {"all_nodes":["nonode@nohost"],"cluster_nodes":["nonode@nohost"]}
# 

sleep 4
curl -X PUT http://127.0.0.1:5984/_users
curl -X PUT http://127.0.0.1:5984/_replicator
curl -X PUT http://127.0.0.1:5984/_global_changes

# curl -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' --data-binary '[{port,5984},{bind_address,<<"0.0.0.0">>},{password,<<"admin">>},{username,<<"admin">>}]' http://127.0.0.1:5984/_cluster_setup
