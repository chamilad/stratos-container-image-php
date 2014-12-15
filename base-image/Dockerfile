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

WORKDIR /opt/

#################################
# Enable ssh - This is not good. http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
# For experimental purposes only
##################################
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN echo 'root:g' | chpasswd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

EXPOSE 22

##################################
# Install Dependent Python Libs
##################################
RUN apt-get update && apt-get install -y git python python-pip python-dev gcc
RUN pip install paho-mqtt
RUN pip install GitPython==0.3.1-beta2
RUN pip install psutil
RUN pip install gittle
RUN pip install pexpect

##################
# Configure Agent
##################
WORKDIR /mnt/

RUN mkdir -p /mnt/packs
ADD packs/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT.zip /mnt/packs/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT.zip
RUN mkdir -p /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT

WORKDIR /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT

RUN unzip -q ../packs/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT.zip

WORKDIR /mnt/

RUN rm -rf packs
RUN mkdir -p /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/payload
RUN mkdir -p /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions
ADD packs/extensions /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions
RUN chmod +x /mnt/apache-stratos-python-cartridge-agent-4.1.0-SNAPSHOT/extensions/*

RUN mkdir -p /var/log/apache-stratos/
RUN touch /var/log/apache-stratos/cartridge-agent-extensions.log

###################
# Setup run script
###################
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
ADD files/populate-user-data.sh /usr/local/bin/populate-user-data.sh
RUN chmod +x /usr/local/bin/populate-user-data.sh
