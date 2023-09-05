#!/bin/bash

echo "<clickhouse>
    <logger>
        <level>debug</level>
        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
        <size>1000M</size>
        <count>3</count>
    </logger>
    <display_name>${CLUSTER_NAME} ${NODE_NAME}</display_name>
    <listen_host>0.0.0.0</listen_host>
    <http_port>8123</http_port>
    <tcp_port>9000</tcp_port>
</clickhouse>" > /etc/clickhouse-server/config.d/network-and-logging.xml

echo "<clickhouse>
    <macros>
        <shard>01</shard>
        <replica>${REPLICA}</replica>
        <cluster>${CLUSTER_NAME}</cluster>
    </macros>
</clickhouse>" > /etc/clickhouse-server/config.d/macros.xml

echo "<clickhouse>
    <remote_servers replace='true'>
        <${CLUSTER_NAME}>
            <secret>${CLUSTER_PASSWORD}</secret>
            <shard>
                <internal_replication>true</internal_replication>
                <replica>
                    <host>${REPLICA_HOST_1}</host>
                    <port>9000</port>
                </replica>
                <replica>
                    <host>${REPLICA_HOST_2}</host>
                    <port>9000</port>
                </replica>
            </shard>
        </${CLUSTER_NAME}>
    </remote_servers>
</clickhouse>" > /etc/clickhouse-server/config.d/remote-servers.xml

echo "<clickhouse>
    <zookeeper>
        <!-- where are the ZK nodes -->
        <node>
            <host>${CLICKHOUSE_KEEPER_1}</host>
            <port>9181</port>
        </node>
        <node>
            <host>${CLICKHOUSE_KEEPER_3}</host>
            <port>9181</port>
        </node>
        <node>
            <host>${CLICKHOUSE_KEEPER_3}</host>
            <port>9181</port>
        </node>
    </zookeeper>
</clickhouse>" > /etc/clickhouse-server/config.d/use-keeper.xml