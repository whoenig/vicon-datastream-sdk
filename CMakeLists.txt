cmake_minimum_required(VERSION 3.5)
project(vicon-datastream-sdk)

set (CMAKE_CXX_STANDARD 11)

find_package(Boost 1.5 COMPONENTS system thread REQUIRED)

include_directories(
  Vicon/CrossMarket/DataStream
  Vicon/CrossMarket
)

# Declare a cpp library
add_library(ViconDataStreamSDK_CPP
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/CoreClient.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/ClientUtils.cpp
  Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore/AxisMapping.cpp
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
  Boost::system
  Boost::thread
  pthread
)

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