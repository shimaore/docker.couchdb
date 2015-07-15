Configuration
=============

FIXME Replace the following notes with a startup script that will:
- look for environment variables such as `COUCHDB_NAME`, `COUCHDB_PORT`, `COUCHDB_ADDRESS`;
- create / update the proper startup scripts replacing those variables using e.g. a Mustache syntax.

Erlang Name
-----------

CouchDB 2.0 requires an Erlang name to be set. The Erlang name must be unique within a cluster.
Edit `/usr/local/couchdb/etc/vm.args` and in the line

    -name couchdb@server.local

replace `server.local` with a Fully-Qualified Domain Name (FQDN) for the server.

Erlang Cookie
-------------

CouchDB 2.0 requires an Erlang cookie to be set. The Erlang cookie must be the same on all servers within a cluster.
Edit `/usr/local/couchdb/etc/vm.args` and in the line

    -setcookie monster

replace `monster` with a random, unique string, shared by all CouchDB instances in a cluster.

(Alternatively you might provide a proper `/home/couchdb/.erlang.cookie` file. The file must be only accessible by its owner. Comment out the `-setcookie` command in `vm.args` for the cookie file to be used.)

CouchDB configuration
---------------------

All CouchDB configuration should be done in `/usr/local/couchdb/etc/local.ini`.
