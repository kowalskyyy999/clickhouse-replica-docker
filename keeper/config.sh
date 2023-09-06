#!/bin/bash

echo "<clickhouse>
    <logger>
        <level>trace</level>
        <log>/var/log/clickhouse-keeper/clickhouse-keeper.log</log>
        <errorlog>/var/log/clickhouse-keeper/clickhouse-keeper.err.log</errorlog>
        <size>1000M</size>
        <count>3</count>
    </logger>
    <listen_host>${HOSTNAME}</listen_host>
    <keeper_server>
        <tcp_port>9181</tcp_port>
        <server_id>${KEEPER_ID}</server_id>
        <log_storage_path>/var/lib/clickhouse/coordination/log</log_storage_path>
        <snapshot_storage_path>/var/lib/clickhouse/coordination/snapshots</snapshot_storage_path>
        <coordination_settings>
            <operation_timeout_ms>10000</operation_timeout_ms>
            <session_timeout_ms>30000</session_timeout_ms>
            <raft_logs_level>trace</raft_logs_level>
        </coordination_settings>
        <raft_configuration>
            <server>
                <id>1</id>
                <hostname>${CLICKHOUSE_KEEPER_1}</hostname>
                <port>9234</port>
            </server>
            <server>
                <id>2</id>
                <hostname>${CLICKHOUSE_KEEPER_2}</hostname>
                <port>9234</port>
            </server>
            <server>
                <id>3</id>
                <hostname>${CLICKHOUSE_KEEPER_3}</hostname>
                <port>9234</port>
            </server>
        </raft_configuration>
    </keeper_server>
    <openSSL>
      <server>
            <!-- Used for secure tcp port -->
            <!-- openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/clickhouse-server/server.key -out /etc/clickhouse-server/server.crt -->
            <certificateFile>/etc/clickhouse-keeper/server.crt</certificateFile>
            <privateKeyFile>/etc/clickhouse-keeper/server.key</privateKeyFile>
            <!-- dhparams are optional. You can delete the <dhParamsFile> element.
                 To generate dhparams, use the following command:
                  openssl dhparam -out /etc/clickhouse-keeper/dhparam.pem 4096
                 Only file format with BEGIN DH PARAMETERS is supported.
              -->
            <dhParamsFile>/etc/clickhouse-keeper/dhparam.pem</dhParamsFile>
            <verificationMode>none</verificationMode>
            <loadDefaultCAFile>true</loadDefaultCAFile>
            <cacheSessions>true</cacheSessions>
            <disableProtocols>sslv2,sslv3</disableProtocols>
            <preferServerCiphers>true</preferServerCiphers>
        </server>
    </openSSL>
</clickhouse>" > /etc/clickhouse-keeper/keeper_config_replica.xml