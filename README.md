# PHP Cartridge Docker image build setup for Apache Stratos

This image setup contains an Ubuntu 14.04 based PHP cartridge with Python implementation of the Cartridge Agent installed.  

##Setup
Clone [this](https://github.com/chamilad/stratos.git) repository and checkout `master` branch. Navigate inside `tools/python-cartridge-agent/`.

Create a folder called `packs` alongside the Dockerfile.

Compress the `cartridge-agent` folder and place the zip file inside `packs` folder as `cartridge-agent.zip`. 

##Create the image.
Execute the following command to create the Docker image from the Dockerfile. You might need sudo to properly run this.

```bash
docker build -t php-4.1.0-m1
```

##Run Container
Execute the following command to start the container in detached mode. You might need sudo to properly run this.

```bash
docker run -d -P --name php-cartridge-01 --env SERVICE_NAME=php --env CLUSTER_ID=cluster1.php.stratos.org --env DEPLOYMENT=default --env PORTS=80 --env MEMBER_ID=member1.cluster1.php.stratos.org --env NETWORK_PARTITION_ID=ec2 --env PARTITION_ID=zone-1 --env CARTRIDGE_KEY=NfxZXmklUvRWslG5 --env REPO_URL=null --env TENANT_ID=1  --env MB_IP=10.219.73.77 --env MB_PORT=61616 --env CEP_IP=10.219.73.77 --env CEP_PORT=7611 php-4.1.0-m1
```

## Expected environment variables

### Mandatory

* MB_IP - Message broker Ip address
* MB_PORT - Message broker port

### Optional

* LISTEN_ADDR - Ip address of the instance, defaults to 'localhost'
* CEP_IP - CEP Ip address, defaults to MB_IP
* CEP_PORT - CEP port, defaults to '7611'
* ENABLE_HEALTH_PUBLISHER - Flag to enable/disable publishing health statistics to a complex event processing server, defaults to 'true'
* LB_PRIVATE_IP - Load balancer's private Ip, defaults to empty
* LB_PUBLIC_IP - Load balancer's public Ip, defaults to empty
* ENABLE_ARTFCT_UPDATE - Flag to enable/disable git based artifacts update, defaults to 'true'
* COMMIT_ENABLED - Flag to enable/disable auto commit to git based repository, defaults to 'false'
* CHECKOUT_ENABLED - Flag to enable/disable auto checkout from git based repository, defaults to 'true'
* ARTFCT_UPDATE_INT - The interval in SECONDS to run the artifact update job, defaults to '15'
* PORT_CHECK_TIMEOUT - The timeout value in MILLISECONDS to wait for ports to be active, defaults to '600000'
* ENABLE_DATA_PUBLISHER - Flag to enable/disable publishing logs to a monitoring server, defaults to 'false'
* MONITORING_SERVER_IP - Monitoring server Ip address, defaults to MB_IP
* MONITORING_SERVER_PORT - Monitoring server port, defaults to '7611'
* MONITORING_SERVER_SECURE_PORT - Monitoring server secure port, defaults to '7711'
* MONITORING_SERVER_ADMIN_USERNAME - Defaults to 'admin'
* MONITORING_SERVER_ADMIN_PASSWORD - Defaults to 'admin'
* LOG_FILE_PATHS - Log files to be included in log publishing to monitoring server, defaults to empty
* APP_PATH - Application root, default to empty
* LOG_LEVEL - Log level to use in cartridge agent logging, defaults to INFO

