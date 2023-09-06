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

RUN yum install -y clickhouse-keeper && \
    systemctl enable clickhouse-keeper.service

RUN dnf install sudo -y

ARG KEEPER_ID
ARG HOSTNAME
ARG CLICKHOUSE_KEEPER_1
ARG CLICKHOUSE_KEEPER_2
ARG CLICKHOUSE_KEEPER_3

ENV KEEPER_ID=${KEEPER_ID}
ENV HOSTNAME=${HOSTNAME}
ENV CLICKHOUSE_KEEPER_1=${CLICKHOUSE_KEEPER_1}
ENV CLICKHOUSE_KEEPER_2=${CLICKHOUSE_KEEPER_2}
ENV CLICKHOUSE_KEEPER_3=${CLICKHOUSE_KEEPER_3}

COPY config.sh config.sh
COPY start_keeper.sh start_keeper.sh

RUN chmod a+x config.sh && \
    chmod a+x start_keeper.sh && \
    ./config.sh

# For testing clickhouse-keeper
RUN dnf install nc -y

VOLUME /var/lib/clickhouse

VOLUME /var/log/clickhouse-keeper

EXPOSE 9181

RUN chown -R clickhouse:clickhouse /var/lib/clickhouse && \
    chown -R clickhouse:clickhouse /var/log/clickhouse-keeper

USER clickhouse

ENTRYPOINT [ "bash", "start_keeper.sh"]