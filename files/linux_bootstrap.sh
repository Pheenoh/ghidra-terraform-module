#!/bin/sh

set -e

# Variable mappings from Terraform
export GHIDRA_URI=${GHIDRA_URI}
export GHIDRA_FOLDER_NAME=${GHIDRA_BASE_FILE}
export GHIDRA_FILE_NAME=${GHIDRA_FILE_NAME}
export INSTALL_PATH=${INSTALL_PATH}
export REPO_PATH=${REPO_PATH}
export BLOCK_DEV_NAME=${BLOCK_DEV_NAME}
export PLATFORM=${PLATFORM}

# Download and install dependencies
yum install unzip wget tar -y
wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
tar xvf $(ls *.tar.gz)
export JAVA_DIR=$(ls -d amazon-corretto-*/)
mv $JAVA_DIR /opt/
cat >>/etc/profile <<EOF
export JAVA_HOME=/opt/$JAVA_DIR
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/profile

# Download and install specified Ghidra version
wget $GHIDRA_URI
unzip $GHIDRA_FILE_NAME
mkdir -p $INSTALL_PATH
mv $GHIDRA_FOLDER_NAME/* $INSTALL_PATH/
rm -rf $GHIDRA_FOLDER_NAME $GHIDRA_FILE_NAME

# Setup server.conf
cat >$INSTALL_PATH/server/server.conf <<EOF
${SERVER_CONF}
EOF

# Make folder for block device mount point
mkdir -p $REPO_PATH

# Check & format the block device with a filesystem (might be a better way to do this...)
FS_VAL=$(lsblk -f $BLOCK_DEV_NAME | awk '{print $2}')
if [[ ! "$FS_VAL" == *"ext4"* ]]; then 
    mkfs.ext4 $BLOCK_DEV_NAME
fi

# Mount the device (need to add mount on boot here too later)
mount $BLOCK_DEV_NAME $REPO_PATH

# Install and run Ghidra
if [[ $PLATFORM == "aws" ]]; then
    sh $INSTALL_PATH/server/svrInstall
else
    # Setup fw rules
    firewall-cmd --add-port=13100-13102/tcp --permanent
    firewall-cmd --reload

    # Startup script
    cat >$INSTALL_PATH/start_ghidra.sh <<EOF
#!/bin/sh

. /etc/profile

$INSTALL_PATH/server/ghidraSvr console
EOF

    # Setup systemd unit file
    chmod +x $INSTALL_PATH/start_ghidra.sh
    cat >/etc/systemd/system/ghidra.service <<EOF
[Unit]
Description=Ghidra collaboration server

[Service]
ExecStart=$INSTALL_PATH/start_ghidra.sh

[Install]
WantedBy=multi-user.target
EOF

# Reload daemons, start Ghidra
systemctl daemon-reload
systemctl enable ghidra
systemctl start ghidra
fi
