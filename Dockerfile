# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER chamilad@wso2.com

RUN apt-get update
RUN apt-get install -y wget

WORKDIR /opt/

#################################
# Enable ssh - This is not good. http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
# For experimental purposes only
##################################

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:g' | chpasswd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

##################
# Install PHP
##################
RUN apt-get install -y apache2 php5 zip unzip
RUN rm /etc/apache2/sites-enabled/000-default.conf
ADD files/000-default.conf /etc/apache2/sites-enabled/000-default.conf

##################################
# Install Dependent Python Libs
##################################

RUN apt-get install -y python-pip python-dev gcc
RUN pip install paho-mqtt
RUN pip install GitPython==0.3.1-beta2
RUN pip install psutil
RUN pip install gittle

##################
# Configure Agent
##################
WORKDIR /mnt/

RUN mkdir -p /mnt/packs
ADD packs/cartridge-agent.zip /mnt/packs/cartridge-agent.zip
RUN unzip -q packs/cartridge-agent.zip
RUN rm -rf packs
RUN mkdir -p /mnt/cartridge-agent/payload
RUN mkdir -p /mnt/cartridge-agent/extensions

EXPOSE 22 80

###################
# Setup run script
###################
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ADD files/populate-user-data.sh /usr/local/bin/populate-user-data.sh
RUN chmod +x /usr/local/bin/populate-user-data.sh 

ENTRYPOINT /usr/local/bin/run | /usr/sbin/sshd -D
