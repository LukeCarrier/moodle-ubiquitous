#
# Ubiquitous Moodle
#
# @author Luke Carrier <luke@carrier.im>
# @copyright 2018 The Ubiquitous Authors
#

FROM ubuntu:16.04
LABEL maintainer "Luke Carrier <luke@carrier.im>"

RUN apt-get update \
        && apt-get install -y \
                ca-certificates \
                apt-transport-https apt-utils debconf-utils \
                python python-apt \
        && rm -rf /var/lib/apt/lists/*
