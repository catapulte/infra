FROM rabbitmq:3-management
RUN apt-get update -y \
 && apt-get install -y python
RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
COPY rabbitmq.sh /
EXPOSE 1883
CMD /rabbitmq.sh
