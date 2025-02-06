# mPower Custom Application - Bash Shell Script Example

This document shows how to build a minimal mPower custom application which executes a bash script named `BashExampleApp.sh`.

**_Note:_** This document assumes that the `mpower_custom_app_template` repo has been cloned into `~/`

**_Note:_** All text files must use the Unix (LF) line ending convention.

**_Note:_** This example uses `kate` as the text editor. Most text editors will suffice.

## Create Application Source Directory

Make a directory for the source code of the application and change into it.

```
$ mkdir -p BashExampleApp/src
$ cd BashExampleApp/src
```

# Required Files

There are a minimum of three required files in an mPower custom application - `manifest.json`, `Install`, and `Start`. 

Follows are instructions on how to copy and edit provided template files for use in the BashExampleApp application.

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
  "AppName": "BashExampleApp",
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

The base `Install` script will not need to be edited in this example.

## Start

The `Start` file is a shell script which is executed by the MultiTech mPower enabled device when the application is started. The `Start` script is responsible for starting and stopping the application.

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
NAME="BashExampleApp"
DAEMON="${APP_DIR}/BashExampleApp.sh"
DAEMON_DEBUG_ARGS=""
DAEMON_ARGS="${DAEMON_DEBUG_ARGS}"
```

Save and close `Start`.

# Bash Example 

Create a bash script for the example that will use the mPower API to get the LoRa device list from installed LoRa network server and write it to a timestamped file.

## BashExampleApp.sh

Open a new file in a text editor named `BashExampleApp.sh`.

```
$ kate BashExampleApp.sh &
```

Put the following text in the file:

```
#!/bin/bash
#
# BashExampleApp.sh - Get LoRa device list from installed LoRa network server.
#

#set -x

DEVICE_LIST=$(lora-query -x device list)

printf -v DATE_TIME_NOW '%(%F_%T)T.%06.0f' ${EPOCHREALTIME/./ }

echo -ne "${DEVICE_LIST}" > "./${DATE_TIME_NOW}-lora_device_list.txt"
```

Save and close `BashExampleApp.sh`.

# Package Custom mPower Application

mPower requires the custom application to be packaged as a gzipped tarball.

Create the gzipped tarball `BashExampleApp_0_0_1.tgz`:

`tar --hard-dereference -hczf BashExampleApp_0_0_1.tgz manifest.json Install Start BashExampleApp.sh`

# Install Custom mPower Application

1. Log into mPower enabled MultiTech device. 
2. Navigate to "Apps".
3. Click "Enabled" checkbox.
4. Click "Add Custom App".
5. Write a random seven digit positive integer in the "App ID" field.
6. Write "BashExampleApp" in the "App Name" field.
7. Click the file chooser icon and select the `BashExampleApp_0_0_1.tgz` file. Application will install and run.

# Read  Custom mPower Application Application Output

1. Navigate to "Administration->Access Configuration".
2. Click the "Enable" checkbox in the "SSH Settings" section and configure as desired.
3. SSH into the device.
4. Change into the installation directory and list timestamped file. 

Example:
```
$ cd /var/persistent/BashExampleApp
$ ls *.txt
2021-09-18:17:55:43.893755-lora_device_list.txt
```
