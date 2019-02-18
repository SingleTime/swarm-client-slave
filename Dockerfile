FROM anapsix/alpine-java:8u192b12_jdk 
MAINTAINER jiangliao jiang.liao080@gmail.com>

#RUN ln /usr/enniu/java/bin/java /usr/bin/java
ARG VERSION=3.28
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
RUN apk add shadow 
RUN apk add curl
RUN apk add git
RUN curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
&& chmod 755 /usr/share/jenkins \
&& chmod 644 /usr/share/jenkins/slave.jar
RUN mkdir -p /tmp/download
COPY docker-17.06.2-ce.tgz  /tmp/download/docker-17.06.2-ce.tgz

RUN cd /tmp/download \
    && tar -xzf  docker-17.06.2-ce.tgz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download \
    && apk del curl \
    && rm -rf /var/cache/apk/*
ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="${VERSION}"

ARG AGENT_WORKDIR=/home/${user}/agent


USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}
