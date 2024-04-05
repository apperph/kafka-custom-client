Clone the sample client repo
1. This repo contains the download apache kafka client you can use to interact with our Amazon MSK cluster.
2. Whenever you will run a kafka client cli command, always make sure that you are in the kafka_2.12-3.5.1 folder directory or you can also add the executable files under the kafka_2.12-3.5.1/bin folder directory.
3. To run some kafka commands, please make sure you've completed all the pre-requisites

**Pre-Requisites**

Java Downloads for All Operating Systems
https://www.java.com/en/download/manual.jsp

Check java current runtime version
java -version

Install Apache Kafka
1. Go to Kafka Homepage - https://kafka.apache.org/
2. Download latest Kafka which is the current version of our MSK cluster
3. In our case, the current MSK cluster Kafka version is 3.5.1 so copy the download link of Scala 2.12  - kafka_2.12-3.5.1.tgz (asc, sha512)
4. wget https://archive.apache.org/dist/kafka/3.5.1/kafka_2.12-3.5.1.tgz
5. tar xfvz kafka_2.12-3.5.1.tgz - to extract the tar file to project root directory

Configure Kafka client plugins
1. For our use case, we will use SASL/IAM for the authentication
2. So we need to download a the iam .jar file for kafka
3. https://github.com/aws/aws-msk-iam-auth/releases
4. Download the latest version
5. Configure the CLASSPATH to point to the location of the .jar file
6. export CLASSPATH=/plugins/aws-msk-iam-auth-2.0.3-all.jar or Copy the .jar file on the /libs folder

NOTE: I've already installed the .jar file under kafka_2.12-3.5.1/libs folder directory. On a fresh installed kafka client, you need to create a new one.

AssumeRole via SDK
https://docs.aws.amazon.com/IAM/latest/UserGuide/sts_example_sts_AssumeRole_section.html

AssumeRole via CLI
aws sts assume-role --role-arn arn:aws:iam::438258006988:role/KafkaSandboxClusterAdministratorRole --role-session-name kafka-client --region ap-southeast-1

Permanently configure on your environment

1. Create a new AWS profile in your local environment using
aws configure --profile advph-dev-paul

Note: use ap-southeast-1 for region and json as output

2. Input your access key id and access key secret

3. Open your AWS config on editor.
sudo vi ~/.aws/config

4. Copy this config at the bottom of the file
[profile kafkasandbox-admin]
role_arn = arn:aws:iam::438258006988:role/KafkaSandboxClusterAdministratorRole
source_profile = advph-dev-paul

NOTE: the source profile should be the profile you configured earlier, in my example I used advph-dev-paul which I configured on the previous steps.

1. Now, we will use kafkasandbox-admin profile as an assumedrole in our client.properties. NOTE: I've already created the client.properties file under kafka_2.12-3.5.1/libs folder directory. On a fresh installed kafka client, you need to create a new one and input this settings to assume role.

#IAM settigns
security.protocol=SASL_SSL
sasl.mechanism=AWS_MSK_IAM
sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="kafkasandbox-admin";
sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler

**Apache Kafka Commands**

NOTE: Make sure you cd in your kafka client directory, (e.g. kafka_2.12-3.5.1)

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