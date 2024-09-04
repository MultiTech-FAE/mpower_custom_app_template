#!/bin/bash
#
# Package mPower custom application into an archive that is ready to 
# upload to device and install.
#

set -x

# Application name.
APP_NAME="example"

# Current working directory.
START_DIR=$(pwd)

# Location of application source files
SRC_DIR=$START_DIR

# Source configuration directory
SRC_CONFIG_DIR="${SRC_DIR}"

# Build directory for mPower application.
BUILD_DIR="${SRC_DIR}/build"

# List of application source files. Separated for clarity.
SRC_FILES="\
${SRC_DIR}/example.py \
"

#
#SRC_CONFIG_FILES
# List of application source configuration files. Separated for clarity.
#
SRC_CONFIG_FILES="\
    ${SRC_DIR}/example.cfg.json \
    ${SRC_DIR}/EXAMPLE_CFG_README.md \
"

#
#MPOWER_APP_FILES
# List of mPower custom application files. Separated for clarity.
#
MPOWER_APP_FILES="\
${SRC_DIR}/Install \
${SRC_DIR}/manifest.json \
${SRC_DIR}/Start \
"

#
#MPOWER_PROVISIONING_FILES
# List of mPower custom application provisioning files. Separated for clarity.
#
MPOWER_PROVISIONING_FILES="\
${SRC_DIR}/p_manifest.json \
"

# Remove old build and create new build directory.
rm -rf "${BUILD_DIR}/"
mkdir -p "${BUILD_DIR}/config/"       || exit 1
mkdir -p "${BUILD_DIR}/provisioning/" || exit 1

# Copy files and directories to build directory.
cp ${SRC_FILES}                 "${BUILD_DIR}/"             || exit 1
cp ${SRC_CONFIG_FILES}          "${BUILD_DIR}/config/"      || exit 1
cp ${MPOWER_APP_FILES}          "${BUILD_DIR}/"             || exit 1
cp ${MPOWER_PROVISIONING_FILES} "${BUILD_DIR}/provisioning" || exit 1

# Create the mPower custom application archive.
# Note: If uploading app to DeviceHQ (https://www.devicehq.com) the 
#       archive file's executable bits must be set.
cd ${BUILD_DIR}                  || exit 1
tar -czvf "${APP_NAME}.tar.gz" * || exit 1
chmod 755 "${APP_NAME}.tar.gz"   || exit 1
cd ${START_DIR}                  || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR}/${APP_NAME}.tar.gz"