cmake_minimum_required(VERSION 3.5)
project(vicon-datastream-sdk)

set (CMAKE_CXX_STANDARD 11)

find_package(Boost 1.5 COMPONENTS system thread REQUIRED)
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

include_directories(
  Vicon/CrossMarket/DataStream
  Vicon/CrossMarket
)

# Declare a cpp library
add_library(ViconDataStreamSDK_CPP STATIC
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/CoreClient.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/CoreClientTimingLog.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCoreUtils/ClientUtils.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCoreUtils/AxisMapping.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/WirelessConfiguration.cpp
  Vicon/CrossMarket/DataStream/ViconCGStreamClientSDK/CGClient.cpp
  Vicon/CrossMarket/DataStream/ViconCGStreamClient/ViconCGStreamClient.cpp
  Vicon/CrossMarket/DataStream/ViconCGStreamClient/CGStreamReaderWriter.cpp
  Vicon/CrossMarket/DataStream/ViconCGStreamClient/ViconCGStreamBayer.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP/DataStreamClient.cpp
  # StreamCommon
  # ViconCGStream
  # ViconCGStreamClient
  # ViconCGStreamClientSDK
  # ViconDataStreamSDKCore
)

target_link_libraries(ViconDataStreamSDK_CPP
  PRIVATE 
    Boost::system
    Boost::thread
    Threads::Threads
)

target_compile_definitions(ViconDataStreamSDK_CPP PRIVATE "_BUILD_STATIC_LIB")

# Declare an executable

include_directories(
  Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP
)

add_executable(ViconDataStreamSDK_CPPTest
  Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPTest/ViconDataStreamSDK_CPPTest.cpp
)

target_link_libraries(ViconDataStreamSDK_CPPTest
  ViconDataStreamSDK_CPP
)