# Docker image build setup for Apache Stratos

This is a sample setup for the modularized Dockerfile system designed for Apache Stratos Kubernetes + Docker functionality. A base image sets up the cartridge agent and the basic tools (+sshd *for now*) required for a service cartridge. This base image is to be used by service Dockerfiles as the base build.

##Setup
### Base image
####apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT.zip
Create a folder named `packs` alongside the Dockerfile.

Clone [this](https://github.com/chamilad/stratos.git) repository and checkout `master` branch. Build Stratos and copy the cartridge agent artifact in to the `packs` folder.

```bash
git clone https://github.com/apache/stratos.git
cd stratos
mvn clean install
cp products/python-cartridge-agent/target/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT.zip <BASE-IMAGE>/packs/
```

####Agent extensions
Inside the packs folder create a folder named `extensions`.

Copy the extension shell script files that should be executed upon various events in to the `packs/extensions` folder. Note that these can be replaced by custom extension scripts by various service images.

### Service Image - Ex: PHP
A service image should use the base image as the basis to add upon.

```Dockerfile
FROM chamilad/stratos-base:0.1
```

Then the service installation and configuration come. Additionally, customized extensions can be included in the service image, which can replace the agent extensions.

```Dockerfile
##################
# Install PHP
##################
RUN apt-get install -y apache2 php5 zip unzip stress
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

#####################
# Add extensions
#####################
ADD packs/extensions /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions
RUN chmod +x /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions/*
```

The service image should use the run script included in the base image as the `ENTRYPOINT`. This is because it is the script which is responsible for configuring and actually starting the cartridge agent at startup. The complete sample Dockerfile for PHP is as follows.

```Dockerfile
FROM chamilad/stratos-base:0.1
MAINTAINER chamilad@wso2.com

##################
# Install PHP
##################
RUN apt-get install -y apache2 php5 zip unzip stress
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

#####################
# Add extensions
#####################
ADD packs/extensions /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions
RUN chmod +x /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions/*

#####################
# Entrypoint
#####################
ENTRYPOINT /usr/local/bin/run | /usr/sbin/sshd -D
```

##Create the images.
The Docker images should be built in the order of base, service. To build an image execute the following command inside the corresponding folder. __Notice the dot at the end of the build command.__ You might need sudo to properly run this.

```bash
docker build -t chamilad/stratos-base .
docker tag {image hash} chamilad/stratos-base:0.1
```

## Expected environment variables

### Mandatory

* MB_IP - Message broker Ip address
* MB_PORT - Message broker port

### Optional

* LISTEN_ADDR - Ip address of the instance, defaults to `localhost`
* CEP_IP - CEP Ip address, defaults to `MB_IP`
* CEP_PORT - CEP port, defaults to `7611`
* CEP_USERNAME - CEP username, defaults to `admin`
* CEP_PASSWORD - CEP password, defaults to `admin`
* ENABLE_HEALTH_PUBLISHER - Flag to enable/disable publishing health statistics to a complex event processing server, defaults to `true`
* LB_PRIVATE_IP - Load balancer's private Ip, defaults to empty
* LB_PUBLIC_IP - Load balancer's public Ip, defaults to empty
* ENABLE_ARTFCT_UPDATE - Flag to enable/disable git based artifacts update, defaults to `true`
* COMMIT_ENABLED - Flag to enable/disable auto commit to git based repository, defaults to `false`
* CHECKOUT_ENABLED - Flag to enable/disable auto checkout from git based repository, defaults to `true`
* ARTFCT_UPDATE_INT - The interval in SECONDS to run the artifact update job, defaults to `15`
* PORT_CHECK_TIMEOUT - The timeout value in MILLISECONDS to wait for ports to be active, defaults to `600000`
* ENABLE_DATA_PUBLISHER - Flag to enable/disable publishing logs to a monitoring server, defaults to `false`
* MONITORING_SERVER_IP - Monitoring server Ip address, defaults to `MB_IP`
* MONITORING_SERVER_PORT - Monitoring server port, defaults to `7611`
* MONITORING_SERVER_SECURE_PORT - Monitoring server secure port, defaults to `7711`
* MONITORING_SERVER_ADMIN_USERNAME - Defaults to `admin`
* MONITORING_SERVER_ADMIN_PASSWORD - Defaults to `admin`
* LOG_FILE_PATHS - Log files to be included in log publishing to monitoring server, defaults to empty
* APP_PATH - Application root, default to empty
* LOG_LEVEL - Log level to use in cartridge agent logging, defaults to `INFO`

