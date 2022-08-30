#!/bin/sh

set -e

# Variable mappings from Terraform
export GHIDRA_URI=${GHIDRA_URI}
export GHIDRA_FOLDER_NAME=${GHIDRA_BASE_FILE}
export GHIDRA_FILE_NAME=${GHIDRA_FILE_NAME}
export INSTALL_PATH=${INSTALL_PATH}
export JAVA_URI="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"

# Download and install dependencies
yum install unzip -y

wget $JAVA_URI
tar xvf openjdk-11.0.2_linux-x64_bin.tar.gz
mv jdk-11.0.2 /opt/
tee /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/opt/jdk-11.0.2
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

. /etc/profile.d/jdk.sh

# Download and install specified Ghidra version
wget $GHIDRA_URI
unzip $GHIDRA_FILE_NAME
mkdir -p $INSTALL_PATH
mv $GHIDRA_FOLDER_NAME/* $INSTALL_PATH
rm -rf $GHIDRA_FOLDER_NAME $GHIDRA_FILE_NAME

# Setup server.conf
cat $INSTALL_PATH/server/server.conf <<EOF
${SERVER_CONF}
EOF

# Setup daemon
sh $INSTALL_PATH/server/svrInstall