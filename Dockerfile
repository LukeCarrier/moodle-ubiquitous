#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2016 Luke Carrier
#

FROM ubuntu:16.04
LABEL maintainer "Luke Carrier <luke@carrier.im>"

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

COPY docker/local /usr/local/ubiquitous/
RUN chmod 0755 /usr/local/ubiquitous/bin/*

# Fix debconf warnings before doing too many package operations, ensure base
# image is up to date
RUN apt-get update \
        && apt-get install -y --no-install-recommends apt-utils \
        && apt-get dist-upgrade -y \
        && apt-get install -y curl sudo

# Install Salt and accomanying configuration
RUN curl -L https://bootstrap.saltstack.com | sh -s -- -X \
        && sed -i "s/#file_client:.*/file_client: local/" /etc/salt/minion
COPY docker/salt/grain/ci /etc/salt/grains
COPY . /srv/salt/
COPY docker/salt/pillar /srv/pillar/

# Apply the states in two passes:
# -> one with no platforms declared to perform the installation of the services
# -> a second with the services started and platforms declared to create
#    databases and configure the services
# This workaround allows Ubiquitous to function despite the lack of an init
# system.
RUN salt-call --local state.apply
COPY docker/salt/pillar_post/* /srv/pillar/
RUN /usr/local/ubiquitous/bin/ubiquitous-ctl start postgresql \
        && cp /usr/local/ubiquitous/share/postgresql-template-charset.sql /tmp/postgresql-template-charset.sql \
        && sudo -u postgres psql --file /tmp/postgresql-template-charset.sql \
        && salt-call --local state.apply \
        && /usr/local/ubiquitous/bin/ubiquitous-ctl stop

# Mark a release as active
RUN sudo -u ubuntu mkdir -p /home/ubuntu/releases/test \
        && mkdir -p /var/run/php \
        && /usr/local/ubiquitous/bin/ubiquitous-set-current-release --manually-reload --domain dev.local --release test
