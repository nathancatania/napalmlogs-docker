# napalmlogs-docker
Run Napalm-logs in a Docker container and output to Kafka.

Napalm-logs provides cross-vendor normalisation for network syslog messages, following the OpenConfig and IETF YANG models.

The default build will allow you to publish to Kafka. If you wish to change this, [clone the git repo](https://github.com/nathancatania/napalmlogs-docker) and edit the Dockerfile and napalm.tmpl files.


## Disclaimer
The Dockerfile from this repo is included in the official [Napalm-logs repository](https://github.com/napalm-automation/napalm-logs), however it is developed independently and not officially affiliated with the Napalm-logs project.

## Usage
There are two methods:
1. Use the pre-built Docker image hosted on Docker Hub (easy, but limited configuration changes).
2. Build the Docker image from scratch using this repo (change the default configuration how you like).

The default configuration included will output to Kafka and disables security for ease of deployment.
__Do not use the pre-built image for production!__

### Using the pre-built image
With Docker installed, simply run:
```
docker run -d -p 514:514/udp nathancatania/napalm-logs:latest
```
This will pull the image and begin listening for incoming messages on port 514.
The default configuration specifies a Kafka broker running on localhost/127.0.0.1 on port 9092, with all data being published to the `syslog.net` topic.

You can change these defaults by specifying ENV variables at runtime. See the __Variables__ section below.

### Building the image from scratch
This method allows you to completely customize the configuration how you like.

The `napalm.tmpl` file is the configuration file that used (it is rendered at container runtime) - all your configuration changes should occur in this file. E.g.: Disabling Kafka, enabling security etc...

If you need to add files to the container, you can modify the Docker file to include additional `COPY` commands which will transfer your files to the container on build of the image. E.g.: Certificate files etc.


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
docker run -d -e KAFKA_BROKER_HOST=192.168.1.200 -e KAFKA_TOPIC=my_topic -p 6000:514/udp -i nathancatania/napalm-logs:latest
```
In this example:
- Internally the container is still listening on port 514, however Docker will map this to external port 6000 on the host. As the user, you will direct your Syslog traffic to port 6000.
- Napalm-logs will connect to a Kafka broker located at 192.168.1.200.
- As the KAFKA_BROKER_PORT variable was NOT included, the default port of 9092 will be used for the Kafka broker connection.
- Data will be published to the Kafka topic `my_topic`.


## Security
The default configuration will execute napalm-logs with the `--disable-security option` enabled.
Do __NOT__ use this for production. Consult the napalm-logs documentation on how to add a certificate & keyfile.

## Altering the Configuration
If you don't want to output to Kafka, you can change the configuration in the napalm.tmpl file. This file is rendered when the container starts based on the ENV variables defined in the Dockerfile (or those specified at runtime).

## Additional Parsers
There is an experimental Cisco IOS parser included. This is mostly untested, but should help with decoding messages from standard Cisco devices (non IOS-XR/NXOS).

To include in your Docker build, uncomment the `COPY` line in the Dockerfile.

Alternatively, you can deploy a pre-built image with IOS support enabled by pulling the tag `nathancatania/napalm-logs:ios`
