**NOTE: Make sure you cd in your kafka client directory, (e.g. kafka_2.12-3.5.1)**

#### Get cluster's brokers
bin/kafka-broker-api-versions.sh --bootstrap-server b-1-public.publicmanagedkafk.35py20.c2.kafka.ap-southeast-1.amazonaws.com:9198 \
--command-config config/client.properties

#### Create topic
bin/kafka-topics.sh --bootstrap-server b-1-public.publicmanagedkafk.35py20.c2.kafka.ap-southeast-1.amazonaws.com:9198 \
--create --topic dev-kafka-topic \
--partitions 1 --replication-factor 2 \
--command-config config/client.properties

#### List all topics
bin/kafka-topics.sh --bootstrap-server b-1-public.publicmanagedkafk.35py20.c2.kafka.ap-southeast-1.amazonaws.com:9198 \
--list \
--command-config config/client.properties

#### Run the Kafka producer
bin/kafka-console-producer.sh --bootstrap-server b-1-public.publicmanagedkafk.35py20.c2.kafka.ap-southeast-1.amazonaws.com:9198 \
--topic dev-kafka-topic \
--producer.config config/client.properties

#### Run the Kafka consumer
bin/kafka-console-consumer.sh --bootstrap-server b-1-public.publicmanagedkafk.35py20.c2.kafka.ap-southeast-1.amazonaws.com:9198 \
--topic dev-kafka-topic \
--consumer.config config/client.properties \
--from-beginning