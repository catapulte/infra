#!/bin/bash
set -e

rabbitmq-server &
RABBIT_PID=$!
echo $RABBIT_PID > /var/run/rabbitmq.pid
rabbitmqctl wait /var/run/rabbitmq.pid

which rabbitmqadpin || {
  rabbitmqadmin=$(find / -type f -name 'rabbitmqadmin')
  cp $rabbitmqadmin /usr/local/bin/rabbitmqadmin
  chmod +x /usr/local/bin/rabbitmqadmin
}

rabbitmqadmin declare queue name=cat.data durable=true
rabbitmqadmin declare queue name=cat.moves durable=true
rabbitmqadmin declare queue name=cat.crosspath durable=true
rabbitmqadmin declare binding source=amq.topic destination=cat.data routing_key=cat.data destination_type=queue

wait
