#!/bin/bash
#
# Package example python3 application into a tar.gz file that will be
# installed as an application.
#

set -x

# Current working directory.
START_DIR=$(pwd)

# Location of application source files
SRC_DIR=$START_DIR

# Build directory for mPower application.
BUILD_DIR="${SRC_DIR}/build"

# Source configuration directory
SRC_CONFIG_DIR="${SRC_DIR}/config"

# Application source files. Separated for clarity.
SRC_FILES="\
${SRC_DIR}/applogger.py \
${SRC_DIR}/appargs.py \
${SRC_DIR}/mpower_api.py \
${SRC_DIR}/python3_example.py \
"

#
#SRC_CONFIG_FILES
# Application source configuration files. Separated for clarity.
#
SRC_CONFIG_FILES="\
    ${SRC_DIR}/example.cfg.json \
    ${SRC_DIR}/EXAMPLE_CFG_README.md \
"

#
#MPOWER_APP_FILES
# All mPower custom application files. Separated for clarity.
#
MPOWER_APP_FILES="\
${SRC_DIR}/Install \
${SRC_DIR}/manifest.json \
${SRC_DIR}/Start \
"

# Confirm required command line argument.
if [ $# -eq 0 ]
  then
    set +x
    echo "No arguments supplied"
    echo "Requires file name prefix that will be used to create archive ending in '.tar.gz'"
    exit 1
fi

# Remove old build and create new build directory.
rm -rf "${BUILD_DIR}/"
mkdir -p "${BUILD_DIR}/config/" || exit 1

# Copy files and directories to build directory.
cp ${SRC_FILES}        "${BUILD_DIR}/"        || exit 1
cp ${SRC_CONFIG_FILES} "${BUILD_DIR}/config/" || exit 1
cp ${MPOWER_APP_FILES} "${BUILD_DIR}/"        || exit 1

# Create the mPower custom application archive.
cd ${BUILD_DIR}       || exit 1
tar -czvf $1.tar.gz * || exit 1
cd ${START_DIR}       || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR}/${1}.tar.gz"