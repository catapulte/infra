#!/bin/bash
set -e

rabbitmq-server &
RABBIT_PID=$!
echo $RABBIT_PID > /var/run/rabbitmq.pid
rabbitmqctl wait /var/run/rabbitmq.pid

which rabbitmqadmin || {
  rabbitmqadmin=$(find / -type f -name 'rabbitmqadmin' | head -n 1)
  cp $rabbitmqadmin /usr/local/bin/rabbitmqadmin
  chmod +x /usr/local/bin/rabbitmqadmin
}

rabbitmqadmin declare queue name=cat.data durable=true
rabbitmqadmin declare queue name=cat.moves durable=true
rabbitmqadmin declare queue name=cat.crosspath durable=true
rabbitmqadmin declare binding source=amq.topic destination=cat.data routing_key=cat.data destination_type=queue

user=${RABBITMQ_USER:guest}
pass=${RABBITMQ_PASSWORD:guest}

rabbitmqctl add_user $user $pass
rabbitmqctl set_permissions $user '.*' '.*' '.*'
rabbitmqctl set_user_tags $user administrator

wait
