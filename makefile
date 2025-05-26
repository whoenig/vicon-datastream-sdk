# Makefile for ViconDataStreamSDKSourcePackagingLinux64

.SUFFIXES :

ifdef CONFIG
ifneq ($(CONFIG),Debug)
ifneq ($(CONFIG),InternalRelease)
ifneq ($(CONFIG),Release)
Error: unknown configuration.
endif
endif
endif
else
CONFIG=Debug
endif

.PHONY: all StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDK_CPPRetimerTest ViconDataStreamSDK_CPPTest ViconDataStreamSDK_CTest

all: ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDK_CPPRetimerTest ViconDataStreamSDK_CPPTest ViconDataStreamSDK_CTest
	@echo Whole tree succeeded
ViconDataStreamSDK_C: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils
ViconDataStreamSDK_CPP: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils
ViconDataStreamSDK_CPPRetimerTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils
ViconDataStreamSDK_CPPTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils
ViconDataStreamSDK_CTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDKCore ViconDataStreamSDKCoreUtils

StreamCommon:
	@echo "\033[1;31mBuilding StreamCommon\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/StreamCommon

ViconCGStream:
	@echo "\033[1;31mBuilding ViconCGStream\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStream

ViconCGStreamClient:
	@echo "\033[1;31mBuilding ViconCGStreamClient\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStreamClient

ViconCGStreamClientSDK:
	@echo "\033[1;31mBuilding ViconCGStreamClientSDK\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStreamClientSDK

ViconDataStreamSDKCore:
	@echo "\033[1;31mBuilding ViconDataStreamSDKCore\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore

ViconDataStreamSDKCoreUtils:
	@echo "\033[1;31mBuilding ViconDataStreamSDKCoreUtils\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDKCoreUtils

ViconDataStreamSDK_C:
	@echo "\033[1;31mBuilding ViconDataStreamSDK_C\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_C

ViconDataStreamSDK_CPP:
	@echo "\033[1;31mBuilding ViconDataStreamSDK_CPP\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP

ViconDataStreamSDK_CPPRetimerTest:
	@echo "\033[1;31mBuilding ViconDataStreamSDK_CPPRetimerTest\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPRetimerTest

ViconDataStreamSDK_CPPTest:
	@echo "\033[1;31mBuilding ViconDataStreamSDK_CPPTest\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPTest

ViconDataStreamSDK_CTest:
	@echo "\033[1;31mBuilding ViconDataStreamSDK_CTest\033[0m"
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CTest

clean:
	@echo "\033[1;31mCleaning $(CONFIG) build\033[0m"
	find . -path '*/$(CONFIG)/*' \( -name '*.[od]' -o -name '*.gch' \) -exec rm -f {} ';'
	find . -name 'moc_*.cxx' -exec rm -f {} ';'
	rm -f lib/$(CONFIG)/*.a
	rm -f lib/$(CONFIG)/*.so
	rm -f bin/$(CONFIG)/*.exe
	rm -f bin/$(CONFIG)/StreamCommon
	rm -f bin/$(CONFIG)/ViconCGStream
	rm -f bin/$(CONFIG)/ViconCGStreamClient
	rm -f bin/$(CONFIG)/ViconCGStreamClientSDK
	rm -f bin/$(CONFIG)/ViconDataStreamSDKCore
	rm -f bin/$(CONFIG)/ViconDataStreamSDKCoreUtils
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_C
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPP
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPPRetimerTest
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPPTest
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CTest

distclean:
	@echo "\033[1;31mCleaning all builds\033[0m"
	find . \( -name '*.[od]' -o -name '*.gch' \) -exec rm -f {} ';'
	find . -name 'moc_*.cxx' -exec rm -f {} ';'
	rm -rf lib
	rm -rf bin
