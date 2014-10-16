FROM shimaore/debian
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

# Install prereqs
RUN apt-get --no-install-recommends -y install \
  build-essential \
  ca-certificates \
  curl \
  erlang-dev \
  erlang-nox \
  git \
  libicu-dev \
  libmozjs185-dev
RUN apt-get --no-install-recommends -y install \
  erlang-reltool \
  erlang-bear \
  erlang-folsom \
  erlang-goldrush

# Build rebar
RUN useradd -m rebar
USER rebar
WORKDIR /home/rebar
RUN curl -L https://github.com/rebar/rebar/archive/2.5.1.tar.gz | tar zxf -
WORKDIR /home/rebar/rebar-2.5.1
RUN ./bootstrap
USER root
RUN cp rebar /usr/local/bin/
RUN chmod 755 /usr/local/bin/rebar

# Build couchdb
RUN mkdir -p /home
RUN git clone http://stephane.shimaore.net/debian/src/couchdb.git /home/couchdb
RUN useradd -m couchdb
USER root
RUN chown -R couchdb:couchdb /home/couchdb
USER couchdb
WORKDIR /home/couchdb
RUN git checkout -b build master
# Expose nodes on external network interface
RUN sed -i'' 's/bind_address = 127.0.0.1/bind_address = 0.0.0.0/' rel/overlay/etc/default.ini
# Build
RUN ./configure
RUN make
# Install
USER root
RUN make install prefix=/usr/local
RUN apt-get purge -y build-essential curl git
RUN apt-get autoremove -y
USER couchdb
EXPOSE 5984 5986
