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
make install  # if you want to install the package
````

## Testing

Run

````
cd build
./ViconDataStreamSDK_CPPTest vicon
````

where vicon is the IP/hostname of the vicon machine.


## Use in other projects

First you need to build and install this package (see above).  Then you can use
it in your own CMake-projects like this:

```cmake
# CMakeLists.txt
find_package(vicon-datastream-sdk)

add_executable(foo foo.cpp)
target_link_libraries(foo PRIVATE vicon-datastream-sdk::ViconDataStreamSDK_CPP)
```

```c++
// foo.cpp
#include <vicon-datastream-sdk/DataStreamClient.h>

// ...your code...
// See ViconDataStreamSDK_CPPTest.cpp for an example how to use the SDK
```


## Notes

Currently this only builds the C++ SDK and associated test application.
