# coding=utf-8
import pika
import json
import dlog
import uuid
'''
rabbitmq:
    image: rabbitmq:management
    container_name: myrabbitmq
    hostname: myrabbitmq
    restart: always
    ports:
      - 5672:5672
      - 15672:15672
    volumes:
      - /var/docker/rabbitmq/data:/var/lib/rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=123456
 '''


class MQConsumer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.queue_declare(queue='api_queue')
        self.channel.basic_qos(prefetch_count=1)
        self.channel.basic_consume('api_queue', on_message_callback=self.callback)

    def start_service(self):
        self.channel.start_consuming()

    def callback(self, channel, method, properties, body):
        dlog.dlog('消费：{}'.format(body))
        result = {"task": 'over'}
        channel.basic_publish(
            exchange='',
            routing_key=properties.reply_to,
            body=json.dumps(result).encode(),
            properties=pika.BasicProperties(correlation_id=properties.correlation_id)
        )
        channel.basic_ack(delivery_tag=method.delivery_tag)


class MQProducer(object):
    def __init__(self):
        credentials = pika.PlainCredentials("admin", "123456")
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host='rabbitmq', port=5672, credentials=credentials))
        self.channel = self.connection.channel()
        self.channel.exchange_declare(exchange='api_ex', exchange_type='fanout')
        self.channel.queue_declare(queue='api_queue')
        self.channel.queue_bind(exchange='api_ex', queue='api_queue')
        self.callbackQueue = self.channel.queue_declare(queue='', exclusive=False)
        self.queueName = self.callbackQueue.method.queue
        self.channel.basic_consume(on_message_callback=self.callback, auto_ack=False, queue=self.queueName)

    def callback(self, channel, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call(self, requestStr):
        dlog.dlog('生产：{}'.format(requestStr))
        self.response = None
        self.corr_id = str(uuid.uuid4().hex)
        properties = pika.BasicProperties(reply_to=self.queueName, correlation_id=self.corr_id)
        self.channel.basic_publish(exchange='api_ex', routing_key='api_queue', body=requestStr, properties=properties)
        while self.response is None:
            self.connection.process_data_events()
        return self.response


