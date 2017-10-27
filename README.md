# napalmlogs-docker
[Unofficial] Run Napalm-logs in a Docker container and output to Kafka.

[This repo is not affiliated with the official Napalm-logs source.](https://github.com/napalm-automation/napalm-logs)
Napalm-logs provides cross-vendor normalisation for network syslog messages, following the OpenConfig and IETF YANG models.


The default build will allow you to publish to Kafka. If you wish to change this, [clone the git repo](https://github.com/nathancatania/napalmlogs-docker) and edit the Dockerfile and napalm.tmpl files.

## Usage
```
docker run -p 6000:6000/udp nathancatania/napalmlogs:latest
```
Current build is untested with compose.

## Variables
By default, the container listens to UDP traffic on port 6000 and will push it to a Kafka broker running on localhost at port 9094.

You can change this by overwriting the ENV variables when launching the container. A list of available variables (and their defaults) is below.
```
PUBLISH_PORT=49017     # Port to publish data to Kafka on
KAFKA_BROKER_HOST=127.0.0.1     # Hostname or IP of the Kafka broker to publish to
KAFKA_BROKER_PORT=9094    # Port of the Kafka broker to publish to
KAFKA_TOPIC=syslog_napalm    # The Kafka topic to push data to.
```
If you want to change the port that the container listens on to receive Syslog data, you can alter the port mapping on container launch.

Example (changing the ENV variables and port mapping)
```
docker run -e KAFKA_BROKER_HOST=192.168.1.200 -e KAFKA_TOPIC=my_topic -p 6789:6000/udp nathancatania/napalmlogs:latest
```
## Security
The default configuration will execute napalm-logs with the `--disable-security option` enabled.
Do __NOT__ use this for production. Consult the napalm-logs documentation on how to add a certificate & keyfile.

## Altering the Configuration
If you don't want to output to Kafka, you can change the configuration in the napalm.tmpl file. This file is rendered when the container starts based on the ENV variables defined in the Dockerfile (or those specified at runtime).
