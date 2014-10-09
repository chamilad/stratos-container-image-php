# PHP Cartridge Docker image build setup for Apache Stratos

This image setup contains an Ubuntu 14.04 based PHP cartridge with Python implementation of the Cartridge Agent installed.  

##Setup
Clone [this](https://github.com/chamilad/stratos.git) repository and checkout `master` branch. Navigate inside `tools/python-cartridge-agent/`.

Compress the `cartridge-agent` folder and place the zip file inside packs/ folder as cartridge-agent.zip. 

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
TODO
