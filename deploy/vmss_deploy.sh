# Update current packages
sudo apt-get update

# Install Gradle, Java, and MongoDB
sudo apt-get install gradle
sudo apt-get install openjdk-8-jdk openjdk-8-jre mongodb

# Install Node and npm
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install npm -y

# Set environment variables for Java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:/usr/lib/jvm/java-8-openjdk-amd64/bin

# Create deployment directory
sudo mkdir /var/lib/partsunlimited

# Kill java to stop current website
sudo pkill -9 'java'

# Remove old artifacts
sudo rm -f /var/lib/partsunlimited/MongoRecords.js*
sudo rm -f /var/lib/partsunlimited/mrp.war*
sudo rm -f /var/lib/partsunlimited/ordering-service-0.1.0.jar*

# Copy files from deployment package
sudo find ../ -iname '*.?ar' -exec cp -t /var/lib/partsunlimited {} +;
sudo find . -iname 'MongoRecords.js' -exec cp -t /var/lib/partsunlimited {} +;

# Add the records to ordering database on MongoDB
sudo mongo ordering /var/lib/partsunlimited/MongoRecords.js

# Change Tomcat listening port from 8080 to 9080
sudo sed -i s/8080/9080/g /etc/tomcat7/server.xml

# Remove existing MRP directory and copy WAR file to Tomcat directory for auto-deployment
sudo rm -rf /var/lib/tomcat7/webapps/mrp
sudo cp /var/lib/partsunlimited/mrp.war /var/lib/tomcat7/webapps

# Restart Tomcat
sudo /etc/init.d/tomcat7 restart

# Run Ordering Service app
sudo java -jar /var/lib/partsunlimited/ordering-service-0.1.0.jar &>/dev/null &

echo "MRP application successfully deployed. Go to http://<YourDNSname>:9080/mrp"