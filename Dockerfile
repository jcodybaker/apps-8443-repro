FROM debian:bullseye-slim

LABEL maintainer="Colin Wilson colin@wyveo.com"

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV php_conf /etc/php/8.2/fpm/php.ini
ENV fpm_conf /etc/php/8.2/fpm/pool.d/www.conf
ENV COMPOSER_VERSION 2.5.8

# Install Basic Requirements
RUN buildDeps='curl gcc make autoconf libc-dev zlib1g-dev pkg-config' \
    && set -x \
    && apt-get update \
    && apt-get install --no-install-recommends $buildDeps --no-install-suggests -q -y gnupg2 dirmngr wget apt-transport-https lsb-release ca-certificates \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
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
    php8.2-fpm \
    php8.2-cli \
    php8.2-bcmath \
    php8.2-dev \
    php8.2-common \
    php8.2-opcache \
    php8.2-readline \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-gd \
    php8.2-imagick \
    php8.2-mysql \
    php8.2-zip \
    php8.2-pgsql \
    php8.2-intl \
    php8.2-xml \
    php-pear \
    && pecl -d php_suffix=8.2 install -o -f redis memcached \
    && mkdir -p /run/php \
    && pip install wheel \
    && pip install supervisor \
    && pip install git+https://github.com/coderanger/supervisor-stdout \
    && echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d \
    # Clean up
    && rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

# Copy required composer files
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
