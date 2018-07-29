# vicon-datastream-sdk
inofficial VICON DataStream SDK with cmake support

Since version 1.8.0, the VICON DataStream SDK is available under an MIT license. This inofficial fork
contains the SDK as well as support for the cmake build system for easy integration in cmake-based projects.

You can find the latest official version at https://vicon.com/downloads/utilities-and-sdk/datastream-sdk

## Building

````
mkdir build
cd build
cmake ..
make
````

## Testing

Run

````
cd build
./ViconDataStreamSDK_CPPTest vicon
````

where vicon is the IP/hostname of the vicon machine.

## Notes

Currently this only builds the C++ SDK and associated test application.