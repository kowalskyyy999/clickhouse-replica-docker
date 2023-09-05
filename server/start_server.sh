/usr/bin/clickhouse start

process_id=`cat /var/run/clickhouse-server/clickhouse-server.pid`
tail -f /proc/${process_id}/fd/3