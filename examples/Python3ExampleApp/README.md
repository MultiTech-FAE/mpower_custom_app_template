# mPower Custom Application - Python3 Script Example

This document shows how to build a minimal mPower custom application which executes a python script named `Python3ExampleApp.py`.

**_Note:_** This document assumes that the `mpower_custom_app_template` repo has been cloned into `~/`

**_Note:_** All text files must use the Unix (LF) line ending convention.

**_Note:_** This example uses `kate` as the text editor. Most text editors will suffice.

## Create Application Source Directory

Make a directory for the source code of the application and change into it.

```
$ mkdir -p Python3ExampleApp/src
$ cd Python3ExampleApp/src
```

# Required Files

In this mPower custom application example there will be five required files.They are named `manifest.json`, `Install`, `Start`, and `status.json` respectively.

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
| :---------------- | :-----: | :---------- |
| AppName           | String  | Name of the application. This is used for the installed app directory name and displaying in the UI and on DeviceHQ |
| AppVersion        | String  | Version of the application. DeviceHQ uses this to distinguish between versions |
| AppDescription    | String  | Description for your purposes |
| AppVersionNotes   | String  | Any applicable notes for the particular version of the application displayed on DeviceHQ |
| SDCard 	        | Boolean | Optional variable. Can not be used with PersistentStorage. Determines where app is installed and saved. A value of `true` uses external SD card. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |
| PersistentStorage | Boolean | Optional variable. Can not be used with SDCard. Determines where app is installed and saved. A value of `true` uses persistent NVRAM that won't be overwritten by a factory default or firmware upgrade. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |

Edit `manifest.json` to read:

```
{
  "AppName": "Python3ExampleApp",
  "AppVersion": "0.0.1",
  "AppDescription": "Example mPower application runs a python script",
  "AppVersionNotes": "First Version",
  "PersistentStorage": true
}
```

Save and close `manifest.json`

## status.json

The `status.json` file is a JSON formatted file that is used by a running application to communicate the application's status to the `app-manager`. Members and descriptions follow:

| Key               | Type    | Description |
| :---------------- | :-----: | :---------- |
| pid               | String  |  Linux Process ID of the application. |
| AppInfo           | String  |  A string containing up to 160 characters that will be displayed on the GUI. |

Copy the `status.json` file provided by the mPower Custom App Template repository to the application source directory.

```
$ cp ~/mpower_custom_app_template/src/status.json .
```

The base `status.json` file will be edited by the running application.

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
NAME="Python3ExampleApp"
DAEMON="${APP_DIR}/Python3ExampleApp.py"
DAEMON_DEBUG_ARGS=""
DAEMON_ARGS="${DAEMON_DEBUG_ARGS}"
```

Save and close `Start`.

# Download And Copy Example Source Code

Download and copy Python3ExampleApp.py into the src directory.

[Python3ExampleApp.py](Python3ExampleApp.py)

# Package Custom mPower Application

mPower requires the custom application to be packaged as a gzipped tarball.

Create the gzipped tarball `Python3ExampleApp_0_0_1.tgz`:

`tar --hard-dereference -hczf Python3ExampleApp_0_0_1.tgz manifest.json Install Start status.json Python3ExampleApp.py`

# Install Custom mPower Application

1. Log into mPower enabled MultiTech device. 
2. Navigate to "Apps".
3. Click "Enabled" checkbox.
4. Click "Add Custom App".
5. Write a random seven digit positive integer in the "App ID" field.
6. Write "Python3ExampleApp" in the "App Name" field.
7. Click the file chooser icon and select the `Python3ExampleApp_0_0_1.tgz` file. Application will install and run.

# Confirm Application Output

1. Log into mPower enabled MultiTech device.
2. Navigate to "Apps"
3. View the current application status in the Python3ExampleApp row.
