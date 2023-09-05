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

RUN systemctl enable clickhouse-server.service

COPY config.sh /config.sh 

# RUN chmod a+x config.sh && \
#         ./config.sh

# RUN cat /etc/clickhouse-server/config.d/remote-servers.xml

# RUN echo "${CLUSTER_NAME}"

VOLUME /var/lib/clickhouse

EXPOSE 8123 8443 9000

RUN chown -R clickhouse:clickhouse /etc/clickhouse-server && \
    chown -R clickhouse:clickhouse /var/lib/clickhouse && \
    chown -R clickhouse:clickhouse /var/log/clickhouse-server && \
    chown -R clickhouse:clickhouse /usr/bin/clickhouse-server

RUN dnf install sudo -y

COPY start_server.sh .
RUN chmod 755 start_server.sh

USER clickhouse

ENTRYPOINT [ "bash", "start_server.sh" ]

# RUN echo "/usr/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml --pid-file=clickhouse-server.pid" > start_server.sh

# RUN echo "tail -f /var/log/clickhouse-server/clickhouse-server.log" > entrypoint.sh

# RUN chmod a+x start_server.sh

# RUN chmod a+x entrypoint.sh

# RUN su clickhouse

# RUN whoami

# RUN ./start_server.sh

# # RUN systemctl start clickhouse-server.service

# ENTRYPOINT [ "bash" , "entrypoint.sh"]

# /usr/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml --pid-file=%t/%p/%p.pid

# /usr/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml --pid-file=clickhouse-server.pid

# chown -R clickhouse:clickhouse /var/lib/clickhouse/
# chown -R clickhouse:clickhouse /var/log/clickhouse-server/
# chown -R clickhouse:clickhouse /etc/clickhouse-server