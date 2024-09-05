#!/bin/bash
#
# Package mPower custom application into an archive that is ready to 
# upload to device and install.
#

set -x

#
#APP_NAME
# Application name. Used to name the packaged tar.gz file.
#
APP_NAME="Python3Example"

#
#START_DIR
# Current working directory.
#
START_DIR=$(pwd)

#
#SRC_DIR
# Location of application source files
#
SRC_DIR=$START_DIR

#
#SRC_CONFIG_DIR
# Local source configuration file directory. Change if not ${SRC_DIR}.
#
SRC_CONFIG_DIR="${SRC_DIR}"

#
#BUILD_DIR
# Local build directory for mPower application.
#
BUILD_DIR="${SRC_DIR}/build"

#
#SRC_FILES
# List of application source files. Separated for clarity.
#
SRC_FILES="\
    ${SRC_DIR}/appargs.py \
    ${SRC_DIR}/applogger.py \
    ${SRC_DIR}/mpower_api.py \
    ${SRC_DIR}/python3_example.py \
"

#
#SRC_CONFIG_FILES
# List of application source configuration files. Separated for clarity.
#
SRC_CONFIG_FILES="\
    ${SRC_CONFIG_DIR}/example.cfg.json \
    ${SRC_CONFIG_DIR}/EXAMPLE_CFG_README.md \
"

#
#MPOWER_APP_FILES
# List of mPower custom application files. Separated for clarity.
#
MPOWER_APP_FILES="\
${SRC_DIR}/manifest.json \
${SRC_DIR}/Install \
${SRC_DIR}/Start \
"

# Remove old build and create new build directory.
rm -rf "${BUILD_DIR}/"
mkdir -p "${BUILD_DIR}/config/" || exit 1


# Copy files and directories to build directory.
cp ${SRC_FILES}                 "${BUILD_DIR}/"             || exit 1
cp ${SRC_CONFIG_FILES}          "${BUILD_DIR}/config/"      || exit 1
cp ${MPOWER_APP_FILES}          "${BUILD_DIR}/"             || exit 1


# Enter build directory.
cd ${BUILD_DIR} || exit 1

# Required `Install` and `Start` scripts must be executable.
chmod 755 "Install" || exit 1
chmod 755 "Start"   || exit 1

#
# Create the mPower custom application archive.
# Note: If uploading app to DeviceHQ (https://www.devicehq.com) the 
#       archive file's executable bits must be set.
#
tar -czvf "${APP_NAME}.tar.gz" * || exit 1
#chmod 755 "${APP_NAME}.tar.gz"   || exit 1
cd ${START_DIR}                  || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR}/${APP_NAME}.tar.gz"