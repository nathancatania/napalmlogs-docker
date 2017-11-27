# napalmlogs-docker
[Unofficial] Run Napalm-logs in a Docker container and output to Kafka.

[This repo is not affiliated with the official Napalm-logs source.](https://github.com/napalm-automation/napalm-logs)
Napalm-logs provides cross-vendor normalisation for network syslog messages, following the OpenConfig and IETF YANG models.


The default build will allow you to publish to Kafka. If you wish to change this, [clone the git repo](https://github.com/nathancatania/napalmlogs-docker) and edit the Dockerfile and napalm.tmpl files.

## Usage
```
docker run -p 514:514/udp nathancatania/napalm-logs:latest
```
Current build is untested with compose.

## Variables
By default, the container listens to UDP traffic on port 514 and will push it to a Kafka broker running on localhost at port 9092.

You can change this by overwriting the ENV variables when launching the container. A list of available variables (and their defaults) is below.
```yaml
PUBLISH_PORT: 49017              # Port to publish data to Kafka on
KAFKA_BROKER_HOST: 127.0.0.1     # Hostname or IP of the Kafka broker to publish to
KAFKA_BROKER_PORT: 9092          # Port of the Kafka broker to publish to
KAFKA_TOPIC: syslog.net          # The Kafka topic to push data to.
SEND_RAW: true                   # Publish messages where the OS, but NOT the message could be identified.
SEND_UNKNOWN: false              # Publish messages where both OS and message could not be identified.
WORKER_PROCESSES: 1              # Increasing this increases memory consumption but is better for higher loads.
```
If you want to change the port that the container listens on to receive Syslog data, you can alter the port mapping on container launch.

Example (changing the ENV variables and port mapping):
```
docker run -d -e KAFKA_BROKER_HOST=192.168.1.200 -e KAFKA_TOPIC=my_topic -p 6789:514/udp -i nathancatania/napalm-logs:latest
```
In this example:
- Internally the container is still listening on port 514, however Docker will map this to external port 6789 on the host. As the user, you will direct your Syslog traffic to port 6789.
- Napalm-logs will connect to a Kafka broker located at 192.168.1.200.
- As the KAFKA_BROKER_PORT variable was NOT included, the default port of 9092 will be used for the Kafka broker connection.
- Data will be published to the Kafka topic `my_topic`.


## Security
The default configuration will execute napalm-logs with the `--disable-security option` enabled.
Do __NOT__ use this for production. Consult the napalm-logs documentation on how to add a certificate & keyfile.

## Altering the Configuration
If you don't want to output to Kafka, you can change the configuration in the napalm.tmpl file. This file is rendered when the container starts based on the ENV variables defined in the Dockerfile (or those specified at runtime).
