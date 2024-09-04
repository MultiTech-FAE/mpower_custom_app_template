# FILES

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
| SDCard 	        | Boolean | Optional variable determines where to save app. If true, it saves to SD card. If false, saves in flash. |
| PersistentStorage | Boolean | Optional variable. When set to true, application is stored and installed from the /var/persistent directory location. |

Example `manifest.json` file:
```
{
  "AppName": "example" ,
  "AppVersion": "0.0.1" ,
  "AppDescription": "custom application example",
  "AppVersionNotes":"First release.",
  "SDCard": false,
  "PersistentStorage": true
}
```


