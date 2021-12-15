FROM jenkins/jenkins:lts-slim

USER root

ENV JENKINS_USER=jenkins

RUN set -eux \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gosu \
        procps \
        rsync \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
