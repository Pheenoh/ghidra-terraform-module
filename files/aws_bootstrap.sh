#!/bin/sh

set -e

# Variable mappings from Terraform
export GHIDRA_URI=${GHIDRA_URI}
export GHIDRA_FOLDER_NAME=${GHIDRA_BASE_FILE}
export GHIDRA_FILE_NAME=${GHIDRA_FILE_NAME}
export INSTALL_PATH=${INSTALL_PATH}

# Download and install dependencies
yum install unzip -y

wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
tar xvf $(ls *.tar.gz)
export JAVA_DIR=$(ls -d amazon-corretto-*/)
mv $JAVA_DIR /opt/
tee /etc/profile.d/jdk.sh <<EOF
export JAVA_HOME=/opt/$JAVA_DIR
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
cat >$INSTALL_PATH/server/server.conf <<EOF
${SERVER_CONF}
EOF

# Setup daemon
sh $INSTALL_PATH/server/svrInstall