# ./provisioning

The mPower custom application framework permits the installation and provisioning of application dependencies. 

mPower uses `opkg` a lightweight package management system to install dependencies. Dependencies are provided as ipk package files used by opkg.

To include dependencies create a `./provisioning` directory in the mPower custom application archive. Populate the directory with a properly written `p_manifest.json` file and the ipk packages to install.

The mPower custom application framework will detect the presence of the `./provisioning` directory, and install the ipk files referenced in the `p_manifest.json` file.

## p_manifest.json

The `p_manifest.json` file is located in the `./provisioning` directory. On mPower custom application installation the mPower custom application framework will read the `p_manifest.json` file and install the indicated ipks.

Note: To find the value for `pkg_name` below use `$ opkg info example_dependency_1.ipk` and copy the value in the "Package:" field.

JSON formatted file contains the following objects and members:

| Key               | Type    | Description |
| :---------------- | :-----: | ----------: |
| pkgs              | Array   | Array of package objects |

| Key               | Type    | Description |
| :---------------- | :-----: | ----------: |
| FileName          | String  | Package object member. File name of ipk located in `./provisioning` to install |
| type              | String  | Package object member. Always "ipk" |
| pkg_name          | String  | Package object member. Package name defined in the ipk |

Example:
```
{
  pkgs: [
    { "FileName": "example_dependency_1.ipk", "type": "ipk", "PkgName": "MyDependency1" },
    { "FileName": "example_dependency_2.ipk", "type": "ipk", "PkgName": "MyDependency2" }
  ]
}
```

