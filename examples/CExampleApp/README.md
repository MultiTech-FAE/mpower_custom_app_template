# mPower Custom Application - Cross-compiled C Example

This document shows how to build a minimal mPower custom application consisting of a cross compiled `C` application named `CExampleApp` that reads from a configuration file and writes it to the system log.

**_Note:_** This document assumes that the `mpower_custom_app_template` repo has been cloned into `~/`

**_Note:_** All text files must use the Unix (LF) line ending convention.

**_Note:_** This example uses `kate` as the text editor. Most text editors will suffice.

**_Note:_** This document assumes that the cross compiler has been installed to `~/local`.

# Cross Compiler Toolchains

MultiTech provides cross compiler toolchains for use on a PC host running a modern distribution of linux. The cross compiler toolchains target specific MultiTech products and mPower versions. Download the correct toolchain for your MultiTech product and install on a modern Linux PC host system.

**_Note:_** This example requires knowledge of cross-compiling, cross compilers, and general software engineering best practices. These subjects are outside of the scope of the document and are not addressed.

**_Note:_** The toolchain installation includes a shell script, usually beginning with `environment-setup`, that sets toolchain-specific environment variables in the current shell. Source this script before compilation so the CMake build environment will use the correct compiler.

# Create Application Source Directory

Make a directory for the source code of the application and change into it.

```
$ mkdir -p CExampleApp/src
$ cd CExampleApp/src
```

# Required Folder and Files For Example

In this mPower custom application example there will be one folder and five required files. They are named `config`, `manifest.json`, `Install`, `Start`, `CExampleApp`, and `example.cfg.json` respectively.

## Configuration Folder `config`

During installation of a mPower custom application the `app-manager` software running on the MultiTech mPower enabled device looks for a subfolder named `config` in the application package. The folder and its contents are installed on the device and the config folder path is passed as an environment variable to the `Start` script.

Make a configuration directory:

```
$ mkdir config
```

Create the example configuration file `example.cfg.json`:

```
$ echo '{"somekey":"somevalue"}' > ./config/example.cfg.json
```

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
  "AppName": "CExampleApp",
  "AppVersion": "0.0.1",
  "AppDescription": "Example mPower application runs a C application that reads a configuration file and writes it to the system log.",
  "AppVersionNotes": "First Version",
  "PersistentStorage": true
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

Edit the following variables to use the provided values in the `Start` script.

**_Note_** The configuration file location is provided by the `CONFIG_DIR` environment variable set by `app-manager` before the `Start` script is run during normal use.

```
NAME="CExampleApp"
DAEMON="${APP_DIR}/CExampleApp"
DAEMON_DEBUG_ARGS=""
DAEMON_ARGS="-c ${CONFIG_DIR}/example.cfg.json ${DAEMON_DEBUG_ARGS}"
```

Save and close `Start`.

# Compile C Example

Compile and link the included `main.c` file using the previously installed cross-compiler.

## Create Build Directory

Exit the `src` directiory, remove existing build dir if exists and create a clean build directory.

```
$ cd ..
$ rm -rf build/
$ mkdir build/
```

Enter build directory.

```
$ cd build/
```

Source script to set cross compiler environment.

```
$ . ~/local/environment-setup-armv7vet2hf-neon-mlinux-linux-gnueabi
```

Build executable file.

```
$ cmake ../
$ make
```

Copy executable to the application source directory.

```
$ cp ./CExampleApp ../src/
```

Leave build directory.

```
$ cd ..
```

# Package Custom mPower Application

mPower requires the custom application to be packaged as a gzipped tarball.

## Create `CExampleApp_0_0_1.tgz`:

Enter the application source directory and build the gzipped tarball.

```
$ cd src/
$ tar --hard-dereference -hczf CExampleApp_0_0_1.tgz *
```

# Install Custom mPower Application

1. Log into mPower enabled MultiTech device. 
2. Navigate to "Apps".
3. Click "Enabled" checkbox.
4. Click "Add Custom App".
5. Write a random seven digit positive integer in the "App ID" field.
6. Write "CExampleApp" in the "App Name" field.
7. Click the file chooser icon and select the `CExampleApp_0_0_1.tgz` file. Application will install and run.

# Confirm Application Output

1. Navigate to "Administration->Access Configuration".
2. Click the "Enable" checkbox in the "SSH Settings" section and configure as desired.
3. SSH into the device.
4. Search system log file for application output.

Example:
```
ssh admin@192.168.2.1
#########################################################
#      mPower(TM) Edge Intelligence Conduit AP AEP      #
#########################################################
admin@192.168.2.1's password:
Last login: Sun Sep 26 14:20:39 2021 from 192.168.2.102
admin@mtcap3:~$ sudo grep CExampleAppLog /var/log/messages
Password:
2021-09-26T14:24:23.990309+00:00 mtcap3 CExampleAppLog: Begin application...
2021-09-26T14:24:23.991111+00:00 mtcap3 CExampleAppLog: Opening configuration file "/var/persistent/CExampleApp/config/example.cfg.json"...
2021-09-26T14:24:23.991759+00:00 mtcap3 CExampleAppLog: Loading configuration file...
2021-09-26T14:24:23.992353+00:00 mtcap3 CExampleAppLog: [1] {"somekey":"somevalue"}
2021-09-26T14:24:23.992864+00:00 mtcap3 CExampleAppLog: Configuration file loaded.
2021-09-26T14:24:23.993326+00:00 mtcap3 CExampleAppLog: Closing configuration file...
2021-09-26T14:24:23.993825+00:00 mtcap3 CExampleAppLog: Configuration file closed.
2021-09-26T14:24:23.994298+00:00 mtcap3 CExampleAppLog: End application.
```
