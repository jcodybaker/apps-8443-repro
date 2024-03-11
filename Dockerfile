FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

# Install Basic Requirements
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
    gnupg2 \
    dirmngr \
    wget \
    apt-transport-https \
    lsb-release \
    ca-certificates \
    curl \
    gcc \
    make \
    autoconf \
    libc-dev \
    zlib1g-dev \
    pkg-config \
    python3-pip \
    python-setuptools \
    git \
    && pip install wheel \
    && pip install supervisor \
    && pip install git+https://github.com/coderanger/supervisor-stdout \
    && echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN echo -n 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6' > /tmp/composer-setup.sig

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
