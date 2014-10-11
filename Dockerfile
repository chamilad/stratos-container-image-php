# --------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# --------------------------------------------------------------

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

RUN apt-get install -y python python-pip python-dev gcc
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
ADD packs/extensions /mnt/cartridge-agent/extensions
RUN chmod +x /mnt/cartridge-agent/extensions/* 

RUN mkdir -p /var/log/apache-stratos/
RUN touch /var/log/apache-stratos/cartridge-agent-extensions.log

EXPOSE 22 80

###################
# Setup run script
###################
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ADD files/populate-user-data.sh /usr/local/bin/populate-user-data.sh
RUN chmod +x /usr/local/bin/populate-user-data.sh 

ENTRYPOINT /usr/local/bin/run | /usr/sbin/sshd -D
