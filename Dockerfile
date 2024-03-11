FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND noninteractive

# Install Basic Requirements
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y python3-pip \
    && pip install supervisor 

RUN echo -n 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6' > /tmp/composer-setup.sig

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
