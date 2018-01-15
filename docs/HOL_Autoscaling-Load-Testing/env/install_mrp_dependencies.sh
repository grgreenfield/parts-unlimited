#!/bin/bash

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/14.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list

# Install PartsUnlimitedMRP dependencies
apt-get update
apt-get upgrade -y
apt-get install openjdk-8-jdk -y
apt-get install openjdk-8-jre -y
apt-get install mongodb -y
apt-get install tomcat7 -y
apt-get install wget -y
sudo apt-get install -y powershell

# Set Java environment variables
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:/usr/lib/jvm/java-8-openjdk-amd64/bin

powershell -ExecutionPolicy Unrestricted -File https://raw.githubusercontent.com/Microsoft/PartsUnlimitedMRP/master/deploy/SSH-MRP-Artifacts.ps1