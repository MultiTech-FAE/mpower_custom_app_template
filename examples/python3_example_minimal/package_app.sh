#!/bin/bash
#
# Package example python3 application into a tar.gz file that will be
# installed as an application.
#

set -x

# Application name.
APP_NAME="python3_example_minimal"

# Current working directory.
START_DIR=$(pwd)

# Location of application source files
SRC_DIR=$START_DIR

# Build directory for mPower application.
BUILD_DIR="${SRC_DIR}/build"

# Source configuration directory
#SRC_CONFIG_DIR="${SRC_DIR}/config"

# Application source files. Separated for clarity.
SRC_FILES="\
${SRC_DIR}/python3_example_minimal.py \
${SRC_DIR}/LICENSE \
"

#
#SRC_CONFIG_FILES
# Application source configuration files. Separated for clarity.
#
SRC_CONFIG_FILES=""

#
#MPOWER_APP_FILES
# All mPower custom application files. Separated for clarity.
#
MPOWER_APP_FILES="\
${SRC_DIR}/Install \
${SRC_DIR}/manifest.json \
${SRC_DIR}/Start \
"

# Remove old build and create new build directory.
rm -rf "${BUILD_DIR}/"
mkdir -p "${BUILD_DIR}"         || exit 1

# Copy files and directories to build directory.
cp ${SRC_FILES}        "${BUILD_DIR}/"        || exit 1
cp ${MPOWER_APP_FILES} "${BUILD_DIR}/"        || exit 1

#
# Create the mPower custom application archive.
#
# Note: If uploading app to DeviceHQ (https://www.devicehq.com) the 
#       archive file's executable bits must be set.
#
cd ${BUILD_DIR}                  || exit 1
tar -czvf "${APP_NAME}.tar.gz" * || exit 1
#chmod 755 "${APP_NAME}.tar.gz"   || exit 1
cd ${START_DIR}                  || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR}/${APP_NAME}.tar.gz"