FROM debian:bullseye-slim

# Install Basic Requirements
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y python3-pip \
    && pip install supervisor 

RUN touch /tmp/example

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/local/bin/supervisord",  "-n", "-c", "/etc/supervisord.conf"]
