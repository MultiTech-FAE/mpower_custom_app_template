#!/bin/bash
#
# package_app.sh
#
#  Create build directory, copy files, and package mPower custom 
#  application into an archive that is ready to upload to device and
#  install.
#
#  Instructions:
#   1. Populate the SRC_FILES variable with the mPower custom 
#      application source and/or executable file(s). Required files are
#      already populated in the  MPOWER_APP_FILES variable and should 
#      not be included in SRC_FILES.
#
#   2. If the mPower custom application uses configuration files that 
#      must persist across mPower firmware updates then populate the
#      SRC_CONFIG_FILES variable and uncomment lines in the 
#      "Build Config" section.
#
#   3. If the mPower custom application requires provisioning and 
#      installation of additional packages then populate the 
#      MPOWER_PROVISIONING_FILES variable and uncomment lines in the 
#      "Build Provisioning" section.
#

#set -x


########################################################################
# Build Variables - Edit as required.
########################################################################

#
#APP_NAME
# Application name. Used to name the packaged tar.gz file.
#
APP_NAME="c_example"

#
#START_DIR
# Current working directory.
#
START_DIR=$(pwd)

#
#SRC_DIR
# Location of application source files.
#
SRC_DIR="${START_DIR}"

#
#SRC_CONFIG_DIR
# Local source configuration file directory. Change if not ${SRC_DIR}.
#
SRC_CONFIG_DIR="${SRC_DIR}"

#
#BUILD_DIR_APP
# Local build directory where files will be copied and archived.
#
BUILD_DIR_APP="${SRC_DIR}/build/app"

#
#BUILD_DIR_APP
# Local build directory where files will be copied and archived.
#
BUILD_DIR_SRC="${SRC_DIR}/build/src"

#
#SRC_FILES
# Required space delimited list of application source and/or executable
# file(s).
#
SRC_FILES="\
    ${BUILD_DIR_SRC}/c_example \
"

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
#SRC_CONFIG_FILES
# Optional space delimited list of application configuration files.
#
SRC_CONFIG_FILES="\
    ${SRC_CONFIG_DIR}/example.cfg.json \
    ${SRC_CONFIG_DIR}/EXAMPLE_CFG_README.md \
"

#
#MPOWER_PROVISIONING_FILES
# Optional space delimited list of mPower custom application 
# provisioning files.
#
# Note: Not used in this example.
#
MPOWER_PROVISIONING_FILES="\
    ${SRC_DIR}/p_manifest.json \
"


########################################################################
# Build Functions
########################################################################

#
# build_src()
#  Copy source and mandatory mPower application files to build dir.
#
build_src() {
    cp ${SRC_FILES}        "${BUILD_DIR_APP}/" || exit 1
    cp ${MPOWER_APP_FILES} "${BUILD_DIR_APP}/" || exit 1

    # Mandatory `Install` and `Start` scripts must be executable.
    chmod 755 "${BUILD_DIR_APP}/Install" || exit 1
    chmod 755 "${BUILD_DIR_APP}/Start"   || exit 1
}

#
# build_config()
#  Copy optional application configuration files to build dir.
#
build_config() {
    mkdir -p "${BUILD_DIR_APP}/config/"               || exit 1
    cp ${SRC_CONFIG_FILES} "${BUILD_DIR_APP}/config/" || exit 1
}

#
# build_provisioning()
#  Copy optional provisioning files to build dir.
#  
build_provisioning() {
    mkdir -p "${BUILD_DIR_APP}/provisioning/"                       || exit 1
    cp ${MPOWER_PROVISIONING_FILES} "${BUILD_DIR_APP}/provisioning" || exit 1
}


########################################################################
# Build and package mPower custom application.
########################################################################

#
# Check for existence of built source.
#
if [ ! -d "${BUILD_DIR_SRC}" ]; then
    echo "Error: '${BUILD_DIR_SRC}' doesn't exist! Run ./build_app.sh first."
    exit 1
fi

# Remove existing build dir if exists and create clean directory.
rm -rf "${BUILD_DIR_APP}"
mkdir -p "${BUILD_DIR_APP}" || exit 1

#
# Build Source
#  Copy source and mandatory mPower application files to build dir.
#
build_src

#
# Build Config
#  Copy optional application configuration files to build dir.
#
# Uncomment if application uses configuration files that must persist
# across mPower firmware updates.
#
build_config

#
# Build Provisioning
#  Copy optional provisioning files to build dir.
#
# Uncomment if application requires provisioning and installation of
# additional packages.
#
#build_provisioning

# Create the mPower custom application archive.
cd ${BUILD_DIR_APP}              || exit 1
tar --hard-dereference -hczf "${APP_NAME}.tgz" * || exit 1
cd ${START_DIR}                  || exit 1

echo "Done. Packaged mPower custom application is in ${BUILD_DIR_APP}/${APP_NAME}.tar.gz"
