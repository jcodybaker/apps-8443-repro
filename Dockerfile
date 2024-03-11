ARG PHP_VERSION=82
ARG NGINX_VERSION=latest
ARG APCU_VERSION=5.1.22

FROM wyveo/nginx-php-fpm:php${PHP_VERSION} AS base

# RUN apt-get update \
#     && apt-get install pip git --no-install-recommends --no-install-suggests -q -y --option=Dpkg::Options::=--force-confdef \
#     && apt-get purge -y --auto-remove $buildDeps \
#     && apt-get clean \
#     && apt-get autoremove

# RUN pip install supervisor && pip install git+https://github.com/coderanger/supervisor-stdout

# Copy required composer files
COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
