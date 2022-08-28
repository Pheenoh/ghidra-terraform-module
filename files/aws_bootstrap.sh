#!/bin/sh

set -e

# Variable mappings from Terraform
GHIDRA_URI          = ${GHIDRA_URI}
REPO_PATH           = ${REPO_PATH}
GHIDRA_FOLDER_NAME  = ${GHIDRA_BASE_FILE}
GHIDRA_FILE_NAME    = ${GHIDRA_FILE_NAME}
INSTALL_PATH        = ${INSTALL_PATH}
INIT_JAVA_HEAP      = ${INIT_JAVA_HEAP}
MAX_JAVA_HEAP       = ${MAX_JAVA_HEAP}
LOG_LEVEL           = ${LOG_LEVEL}

function replaceLine() {
    sed -i "s/$1.*/$2/" $INSTALL_PATH/server/server.conf
}

function installGhidra() {
    # Download and install specified OpenJDK version
    yum install java-11-openjdk-devel unzip -y

    # Download and install specified Ghidra version
    wget $GHIDRA_URI
    unzip $GHIDRA_FILE_NAME
    mkdir -p $INSTALL_PATH
    mv $GHIDRA_FOLDER_NAME/* $INSTALL_PATH
    rm -rf $GHIDRA_FOLDER_NAME

    # Setup server.conf
    if [ ${SERVER_CONF} == "default" ]; then
        # Replace server.conf defaults with TF module variable values
        replaceLine "ghidra.repositories.dir" "ghidra.repositories.dir=$REPO_PATH"
        replaceLine "wrapper.java.initmemory" "wrapper.java.initmemory=$INIT_JAVA_HEAP"
        replaceLine "wrapper.java.maxmemory" "wrapper.java.maxmemory=$MAX_JAVA_HEAP"
        replaceLine "wrapper.logfile.loglevel" "wrapper.logfile.loglevel=$LOG_LEVEL"
    else
        # Replace server.conf with the one that was passed in
        echo ${SERVER_CONF} > $INSTALL_PATH/server/server.conf
    fi

    # Setup daemon
    sh $INSTALL_PATH/server/svrInstall
}

installGhidra()