FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

# Install prereqs
RUN apt-get update && apt-get --no-install-recommends -y install \
  build-essential \
  ca-certificates \
  curl \
  erlang-dev \
  erlang-nox \
  git \
  libicu-dev \
  libmozjs185-dev
RUN apt-get --no-install-recommends -y install \
  erlang-reltool

# Build rebar
RUN useradd -m rebar
USER rebar
WORKDIR /home/rebar
RUN curl -L https://github.com/rebar/rebar/archive/2.5.0.tar.gz | tar zxf -
WORKDIR /home/rebar/rebar-2.5.0
RUN ./bootstrap
USER root
RUN cp rebar /usr/local/bin/
RUN chmod 755 /usr/local/bin/rebar

# Build couchdb
RUN useradd -m couchdb
USER couchdb
WORKDIR /home/couchdb
RUN git clone http://git-wip-us.apache.org/repos/asf/couchdb.git couchdb.git
# RUN git clone https://github.com/apache/couchdb.git couchdb.git
WORKDIR couchdb.git
RUN git checkout -b build master
# Expose nodes on external network interface
RUN sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' rel/overlay/etc/default.ini
# Build
RUN ./configure -p /usr/local/couchdb
RUN make

# Install
USER root
RUN make install
RUN git log > /usr/local/couchdb/.git.log
RUN chown -R couchdb.couchdb /usr/local/couchdb/etc/

# Cleanup source
WORKDIR ..
RUN rm -rf couchdb.git

# Cleanup
RUN apt-get purge -y build-essential curl git
RUN apt-get autoremove -y
USER couchdb
RUN sed -i -e 's/^-name .*$/-name couchdb@server.local/' /usr/local/couchdb/etc/vm.args
EXPOSE 5984 5986
CMD ["/usr/local/couchdb/bin/couchdb","-d"]
