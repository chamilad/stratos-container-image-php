# PHP Cartridge Docker image build setup for Apache Stratos

This image setup contains an Ubuntu 14.04 based PHP cartridge with Python implementation of the Cartridge Agent installed.  

##Setup
###cartridge-agent.zip
Create a folder named `packs` alongside the Dockerfile.

Clone [this](https://github.com/chamilad/stratos.git) repository and checkout `master` branch. Navigate inside `tools/python-cartridge-agent/`. Compress the `cartridge-agent` folder and place the zip file inside `packs` folder as `cartridge-agent.zip`. 

###Agent extensions
Inside the packs folder create a folder named `extensions`. 

Copy the extension shell script files that should be executed upon various events in to the `packs/extensions` folder.

##Create the image.
Execute the following command to create the Docker image from the Dockerfile. You might need sudo to properly run this.

```bash
docker build -t chamilad/php-4.1.0-m2-py .
```

##Run Container
Execute the following command to start the container in detached mode. Set the values for the environment variables You might need sudo to properly run this.

```bash
docker run -d -P --name php-cartridge-08 --env SERVICE_NAME=php --env HOST_NAME=test2.php.stratos.com --env MULTITENANT=false --env TENANT_ID=1 --env TENANT_RANGE=* --env CARTRIDGE_ALIAS=php-my --env CLUSTER_ID=php.my.chamilad.com --env CARTRIDGE_KEY=BNdP01v8VEQPPYGY --env DEPLOYMENT=default --env REPO_URL=https://github.com/chamilad/NeWoice.git --env PORTS=80 --env PUPPET_IP=192.168.16.29 --env PUPPET_HOSTNAME=puppet.chamilad.com --env PUPPET_ENV=env --env MEMBER_ID=member1.cluster1.php.stratos.org --env LB_CLUSTER_ID=null --env NETWORK_PARTITION_ID=null --env PARTITION_ID=null --env APP_PATH=/var/www/www/ --env MIN_COUNT=1 --env MB_IP=10.100.5.140 --env MB_PORT=1883 --env LOG_LEVEL=DEBUG chamilad/php-4.1.0-m2-py
```

## Expected environment variables

### Mandatory

* MB_IP - Message broker Ip address
* MB_PORT - Message broker port

### Optional

* LISTEN_ADDR - Ip address of the instance, defaults to `localhost`
* CEP_IP - CEP Ip address, defaults to `MB_IP`
* CEP_PORT - CEP port, defaults to `7611`
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

