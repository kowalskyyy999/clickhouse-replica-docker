FROM almalinux:9

RUN dnf -y groupinstall 'Development Tools' && \
	dnf -y install ncurses-devel openssl-devel elfutils-libelf-devel

RUN dnf upgrade --refresh -y && \
    dnf install -y \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-8.noarch.rpm

RUN useradd -m clickhouse

RUN echo clickhouse:password123 | chpasswd

RUN chown -R clickhouse:clickhouse /home/clickhouse && \
    usermod -a -G wheel clickhouse

RUN yum install -y yum-utils

RUN yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo

RUN yum install -y clickhouse-server clickhouse-client

RUN dnf install sudo -y

RUN systemctl enable clickhouse-server.service

ARG CLUSTER_NAME
ARG CLUSTER_PASSWORD
ARG NODE_NAME
ARG REPLICA
ARG REPLICA_HOST_1
ARG REPLICA_HOST_2
ARG CLICKHOUSE_KEEPER_1
ARG CLICKHOUSE_KEEPER_2
ARG CLICKHOUSE_KEEPER_3

ENV CLUSTER_NAME=${CLUSTER_NAME}
ENV CLUSTER_PASSWORD=${CLUSTER_PASSWORD}
ENV NODE_NAME=${NODE_NAME}
ENV REPLICA=${REPLICA}
ENV REPLICA_HOST_1=${REPLICA_HOST_1}
ENV REPLICA_HOST_2=${REPLICA_HOST_2}
ENV CLICKHOUSE_KEEPER_1=${CLICKHOUSE_KEEPER_1}
ENV CLICKHOUSE_KEEPER_2=${CLICKHOUSE_KEEPER_2}
ENV CLICKHOUSE_KEEPER_3=${CLICKHOUSE_KEEPER_3}

COPY config.sh /config.sh 

COPY start_server.sh /start_server.sh 

RUN chmod a+x config.sh && \
    chmod a+x start_server.sh && \
        ./config.sh

VOLUME /var/lib/clickhouse

EXPOSE 8123 8443 9000

RUN chown -R clickhouse:clickhouse /etc/clickhouse-server && \
    chown -R clickhouse:clickhouse /var/lib/clickhouse && \
    chown -R clickhouse:clickhouse /var/log/clickhouse-server && \
    chown -R clickhouse:clickhouse /usr/bin/clickhouse-server

USER clickhouse

ENTRYPOINT [ "bash", "start_server.sh" ]