# c_example

The C language mPower custom application example uses a cross compiler to compile source files to an executable that can be run on the target device and packages it into an archive to install.

# Cross Compiler

MultiTech provides cross compiler toolchains for use on a PC host running a modern distribution of linux. The cross compiler toolchains target specific multitech products.

The toolchain installation includes a shell script, usually beginning with `environment-setup` that sets toolchain-specific environment variables in the current shell.

# Building

1. Run the toolchain sepecific environment-setup script.
2. Run the included `build_app.sh` script. Results will be in the `../build/c_example` directory.
3. Run the included `package_app.sh` script. Results will be in the `../build/c_example/mpower_app` directory.