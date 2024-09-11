#!/bin/bash
#
# build_app.sh
#

SRC_DIR=$(pwd)
BUILD_DIR="../build/c_example"

# Remove existing build dir if exists and create clean directory.
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}" || exit 1

# Enter build directory.
cd "${BUILD_DIR}" || exit 1

# Build executable file.
cmake "${SRC_DIR}" || exit 1
make               || exit 1

#Return to original directory.
cd "$SRC_DIR" || exit 1