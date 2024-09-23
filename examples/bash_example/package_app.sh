#!/bin/bash
#
# package_app.sh
#
#  Create build directory, copy files, and package mPower custom 
#  application into an archive that is ready to upload to device and
#  install.
#

#
# Uncomment for verbose script output.
#
#set -x


########################################################################
# Build Variables - Edit as required.
########################################################################

#
#APP_NAME
# Application name. Used to name the packaged tar.gz file.
#
APP_NAME="bash_example"

#
#START_DIR
# Current working directory.
#
START_DIR=$(pwd)

#
#SRC_DIR
# Location of application source files.
#
SRC_DIR=$START_DIR

#
#SRC_CONFIG_DIR
# Local source configuration file directory. Change if not ${SRC_DIR}.
#
SRC_CONFIG_DIR="${SRC_DIR}"

#
#SRC_PROVISIONING_DIR
# Local source provisioning directory. Change if not ${SRC_DIR}.
#
# Note: Not used in this example.
#
SRC_PROVISIONING_DIR="${SRC_DIR}"

#
#BUILD_DIR
# Local build directory where files will be copied and archived.
#
BUILD_DIR="${SRC_DIR}/build/app"

#
#MPOWER_APP_FILES
# Required space delimited list of mPower custom application files.
#
MPOWER_APP_FILES="\
    ${SRC_DIR}/manifest.json \
    ${SRC_DIR}/Install \
    ${SRC_DIR}/Start \
"

#
#SRC_FILES
# Optional space delimited list of application source and/or executable
# file(s).
#
SRC_FILES="\
    ${SRC_DIR}/bash_example.sh \
    ${SRC_DIR}/README.md \
"

########################################################################
# Build Functions
########################################################################

#
# build_mpower_app()
#  Copy mandatory mPower application files to build dir.
#
build_mpower_app() {
    cp ${MPOWER_APP_FILES} "${BUILD_DIR}/" || exit 1
    
    # Mandatory `Install` and `Start` scripts must be executable.
    chmod 755 "${BUILD_DIR}/Install" || exit 1
    chmod 755 "${BUILD_DIR}/Start"   || exit 1
}

#
# package_src()
#  Copy source mPower application files to build dir.
#
package_src() {
    cp ${SRC_FILES} "${BUILD_DIR}/" || exit 1
}


########################################################################
# Build and package mPower custom application.
########################################################################

#
# Prepare build directory.
#
rm -rf "${BUILD_DIR}/"
mkdir -p "${BUILD_DIR}/" || exit 1

#
# Build mPower Application
#  Copy mandatory mPower application files to build dir. Required.
#
build_mpower_app

#
# Package Source
#  Copy source mPower application files to build dir.
#
# Uncomment if application uses source and/or executable files.
#
package_src

# Create the mPower custom application archive.
cd ${BUILD_DIR}                  || exit 1
tar -czvf "${APP_NAME}.tar.gz" * || exit 1
cd ${START_DIR}                  || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR}/${APP_NAME}.tar.gz"