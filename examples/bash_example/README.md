# mPower Custom Application - Bash Shell Script Example

This document shows how to build a minimal mPower custom application that executes a bash script named `BashExample.sh`.

**_Note:_** This document assumes that the `mpower_custom_app_template` repo has been cloned into `~/`
**_Note:_** All text files must use the Unix (LF) line ending convention.

## Create Application Source Directory

Make a directory for the source code of the application and change into it.

```
$ mkdir -p bash_example/src
$ cd bash_example/src
```

# Required Files

Next will be copying and editing the three minimum required files in an mPower custom application - `manifest.json`, `Install`, and `Start`.

## manifest.json

The `manifest.json` file is a JSON formatted file that is used by the `app-manager` software running on the MultiTech mPower enabled device during the installation process to identify the application and specify where it will be installed.

Copy and rename `manifest.json.basic.example` provided by the mPower Custom App Template repository to the application source directory.

```
$ cp ~/mpower_custom_app_template/src/manifest.json.basic.example ./manifest.json
```

Open `manifest.json` in a text editor.

```
$ kate manifest.json &
```

The `manifest.json` file is a JSON formatted file contains the following members:

| Key               | Type    | Description |
| :---------------- | :-----: | ----------: |
| AppName           | String  | Name of the application. This is used for the installed app directory name and displaying in the UI and on DeviceHQ |
| AppVersion        | String  | Version of the application. DeviceHQ uses this to distinguish between versions |
| AppDescription    | String  | Description for your purposes |
| AppVersionNotes   | String  | Any applicable notes for the particular version of the application displayed on DeviceHQ |
| SDCard 	        | Boolean | Optional variable. Can not be used with PersistentStorage. Determines where app is installed and saved. A value of `true` uses external SD card. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |
| PersistentStorage | Boolean | Optional variable. Can not be used with SDCard. Determines where app is installed and saved. A value of `true` uses persistent NVRAM that won't be overwritten by a factory default or firmware upgrade. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |

Edit `manifest.json` to read:

```
{
  "AppName": "BashExample",
  "AppVersion": "0.0.1",
  "AppDescription": "Example mPower application runs a Bash script",
  "AppVersionNotes":"First Version"
}
```

Save and close `manifest.json`

## Install

The `Install` file is a shell script which is executed by the `app-manager` software running on the MultiTech mPower enabled device during the installation process. The `Install` script is responsible for installing additional packages, performing configuration, and/or other tasks that should be done during the application installation.

Copy the base `Install` script provided by the mPower Custom App Template repository to the application source directory.

```
$ cp ~/mpower_custom_app_template/src/Install .
```

The base `Install` script will not need to be edited for this application.

## Start

The `Start` file is a shell script which is executed by the MultiTech mPower enabled device when the application is started. The `Start` script is responsible for FIXME.

Copy the base `Start` script provided by the mPower Custom App Template repository to the application source directory.

```
$ cp ~/mpower_custom_app_template/src/Start .
```

Open `Start` in a text editor.

```
$ kate Start &
```

Edit the variable values to the provided values in the `Start` script:

```
NAME="BashExample"
DAEMON="${APP_DIR}/BashExample.sh"
DAEMON_DEBUG_ARGS=""
DAEMON_ARGS="${DAEMON_DEBUG_ARGS}"
```

Save and close `Start`.

## BashExample.sh

Open a new file in a text editor.

```
$ kate BashExample.sh &
```

Put the following text in the file:

```
#!/bin/bash
#
# BashExample.sh - Get device serial number, log, and quit application.
#

set -x

#Use mPower API to get device serial number (AKA deviceID)
DEVICE_ID=$(wget -qO- --no-check-certificate https://127.0.0.1/api/system/deviceId)

#Log result to /var/log/messages
logger -t BashExample $DEVICE_ID
```

Save and close `BashExample.sh`.

Bash script example gets device serial number using the mPower HTTP API, and writes output to `/var/log/messages`.


To package run:

`$ ./package_app.sh`

Packaged application will be in `./build/app/bash_example.tar.gz`
