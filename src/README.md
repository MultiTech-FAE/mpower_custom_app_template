# mPower Custom Application Framework

The mPower custom application framework provides a highly flexible minimal framework for third-parties to run both python3 and compiled applications on mPower enabled MultiTech hardware.

# Files

## manifest.json

A minimal mPower custom application requires a configuration file named `manifest.json` located in the top level directory of the packaged app.

The `manifest.json` file is used during installation to identify the application and specify where it will be installed.

JSON formatted file contains the following members:

| Key               | Type    | Description |
| :---------------- | :-----: | ----------: |
| AppName           | String  | Name of the application. This is used for the installed app directory name and displaying in the UI and on DeviceHQ |
| AppVersion        | String  | Version of the application. DeviceHQ uses this to distinguish between versions |
| AppDescription    | String  | Description for your purposes |
| AppVersionNotes   | String  | Any applicable notes for the particular version of the application displayed on DeviceHQ |
| SDCard 	        | Boolean | Optional variable. Can not be used with PersistentStorage. Determines where app is installed and saved. A value of `true` uses external SD card. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |
| PersistentStorage | Boolean | Optional variable. Can not be used with SDCard. Determines where app is installed and saved. A value of `true` uses persistent NVRAM that won't be overwritten by a factory default or firmware upgrade. A value of `false` uses non-persistent internal NVRAM which may be overwritten during factory reset and firmware upgrades. |

Three example manifest.json files are provided. To use, copy desired manifest file to application and rename to `manifest.json`.

## p_manifest.json

Used when an mPower custom application requires the installation of dependencies using the installed opkg package manager.