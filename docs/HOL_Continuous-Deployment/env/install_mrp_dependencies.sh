#!/bin/bash
 
DEBIAN_FRONTEND=noninteractive
 
# Install PartsUnlimitedMRP dependencies
apt-get update -yq
apt-get install openjdk-8-jdk -yq
apt-get install openjdk-8-jre -yq
apt-get install mongodb -yq
apt-get install tomcat7 -yq
apt-get install wget -yq
 
# Set Java environment variables
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:/usr/lib/jvm/java-8-openjdk-amd64/bin