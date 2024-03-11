FROM debian:bullseye-slim

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Install Basic Requirements
RUN buildDeps='curl gcc make autoconf libc-dev zlib1g-dev pkg-config' \
    && set -x \
    && apt-get update \
    && apt-get install --no-install-recommends $buildDeps --no-install-suggests -q -y gnupg2 dirmngr wget apt-transport-https lsb-release ca-certificates \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
    apt-utils \
    nano \
    zip \
    unzip \
    python3-pip \
    python-setuptools \
    git \
    libmemcached-dev \
    libmemcached11 \
    libmagickwand-dev \
    && pip install wheel \
    && pip install supervisor \
    && pip install git+https://github.com/coderanger/supervisor-stdout \
    && echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

# Copy required composer files
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
