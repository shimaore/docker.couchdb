#
# Build a CouchDB latest (2.x) Docker.io image
#
FROM shimaore/debian:2.0.16
MAINTAINER Stéphane Alnet <stephane@shimaore.net>
ENV DEBIAN_FRONTEND noninteractive

# Install prereqs
RUN apt-get update && apt-get --no-install-recommends -y install \
  build-essential \
  ca-certificates \
  curl \
  erlang-base-hipe \
  erlang-dev \
  erlang-nox \
  erlang-reltool \
  git \
  libcurl4-openssl-dev \
  libicu-dev \
  libmozjs185-dev \
  pkg-config \
  && \

# Prereqs for building Fauxton
  apt-get clean && \
  git clone https://github.com/tj/n.git n.git && \
  cd n.git && \
  make install && \
  cd .. && \
  n 7.0.0 && \
  rm -r n.git && \

# Build couchdb
  useradd -m -u 9999 couchdb && \
  mkdir -p /opt/couchdb && \
  chown -R couchdb.couchdb /opt/couchdb
USER couchdb
RUN \
  cd /home/couchdb && \
  # Use mirror.
  git clone -b 2.0.x https://github.com/apache/couchdb.git couchdb.git && \
  cd couchdb.git && \
  git checkout e5afeb869765338c34267db78fab2bf2a1464a31 && \
  # Expose nodes on external network interface
  sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' rel/overlay/etc/default.ini && \

# Build
  ./configure --prefix /opt/couchdb --disable-docs && \
  make release && \

# Install
  mv rel/couchdb/* /opt/couchdb/ && \

# Cleanup source
  cd .. && \
  rm -rf couchdb.git

# Cleanup
USER root
RUN apt-get purge -y \
  build-essential \
  git \
  && \
  apt-get autoremove -y

USER couchdb
# Finalize
WORKDIR /opt/couchdb
# Note: vm.args says `-name couchdb` which is incorrect for an Erlang long name.
# RUN sed -i -e 's/^-name .*$/-name couchdb@server.local/' /opt/couchdb/lib/couchdb/etc/vm.args
EXPOSE 5984 5986
CMD ["/opt/couchdb/bin/couchdb","-d"]
