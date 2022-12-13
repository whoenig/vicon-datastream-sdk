cmake_minimum_required(VERSION 3.5)
project(vicon-datastream-sdk VERSION 1.11.0)

set (CMAKE_CXX_STANDARD 11)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

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

target_include_directories(ViconDataStreamSDK_CPP PUBLIC
  PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}>"
)

target_compile_definitions(ViconDataStreamSDK_CPP PRIVATE "_BUILD_STATIC_LIB")

# Declare an executable

add_executable(ViconDataStreamSDK_CPPTest
  Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPTest/ViconDataStreamSDK_CPPTest.cpp
)

target_link_libraries(ViconDataStreamSDK_CPPTest
  ViconDataStreamSDK_CPP
)


# install headers
install(
  FILES
    Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP/DataStreamClient.h
    Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP/IDataStreamClientBase.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
)
# install libraries
install(
  TARGETS ViconDataStreamSDK_CPP
  EXPORT ${PROJECT_NAME}Targets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
# install export targets file
install(
  EXPORT ${PROJECT_NAME}Targets
  FILE ${PROJECT_NAME}Targets.cmake
  NAMESPACE ${PROJECT_NAME}::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

# generate and install package config and version files
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  VERSION "${CMAKE_PROJECT_VERSION}"
  COMPATIBILITY AnyNewerVersion
)
install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
  DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
)
