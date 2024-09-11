#
# CMakeLists.txt
#  Top level CMake file for building C language mPower custom app.
#

cmake_minimum_required(VERSION 3.12)

# Build Versioning
set (APP_VERSION_MAJOR 0)
set (APP_VERSION_MINOR 0)
set (APP_VERSION_PATCH 1)
set (APP_VERSION ${APP_VERSION_MAJOR}.${APP_VERSION_MINOR}.${APP_VERSION_PATCH})

# Files
set (APP_EXE_NAME c_example_minimal)
set (APP_C_SRC_FILES main.c)

# Project
project (
    c_example
    VERSION ${APP_VERSION}
    DESCRIPTION "C language mPower custom app example."
)

# Create an executable.
add_executable (
    ${APP_EXE_NAME}
    ${APP_C_SRC_FILES}
)

#Add compile time #defines
target_compile_definitions (
    ${APP_EXE_NAME} 
    PUBLIC 
    EXE_NAME="${APP_EXE_NAME}"
)

#Add required compiler flags.
include(CheckCCompilerFlag)

#Add compiler and linker flags.
list (APPEND GCC_CFlags "-Wall")
list (APPEND GCC_CFlags "-fdiagnostics-color")

target_compile_options(${APP_EXE_NAME} PUBLIC ${GCC_CFlags})
