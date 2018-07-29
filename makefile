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

.PHONY: all StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDKCore ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDK_CPPRetimerTest ViconDataStreamSDK_CPPTest ViconDataStreamSDK_CTest

all: ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDK_CPPRetimerTest ViconDataStreamSDK_CPPTest ViconDataStreamSDK_CTest
	@echo Whole tree succeeded
ViconDataStreamSDK_C: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore
ViconDataStreamSDK_CPP: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDKCore
ViconDataStreamSDK_CPPRetimerTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore
ViconDataStreamSDK_CPPTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_CPP ViconDataStreamSDKCore
ViconDataStreamSDK_CTest: StreamCommon ViconCGStream ViconCGStreamClient ViconCGStreamClientSDK ViconDataStreamSDK_C ViconDataStreamSDK_CPP ViconDataStreamSDKCore

StreamCommon:
	@echo \[1\;31mBuilding StreamCommon\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/StreamCommon

ViconCGStream:
	@echo \[1\;31mBuilding ViconCGStream\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStream

ViconCGStreamClient:
	@echo \[1\;31mBuilding ViconCGStreamClient\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStreamClient

ViconCGStreamClientSDK:
	@echo \[1\;31mBuilding ViconCGStreamClientSDK\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconCGStreamClientSDK

ViconDataStreamSDKCore:
	@echo \[1\;31mBuilding ViconDataStreamSDKCore\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDKCore

ViconDataStreamSDK_C:
	@echo \[1\;31mBuilding ViconDataStreamSDK_C\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_C

ViconDataStreamSDK_CPP:
	@echo \[1\;31mBuilding ViconDataStreamSDK_CPP\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPP

ViconDataStreamSDK_CPPRetimerTest:
	@echo \[1\;31mBuilding ViconDataStreamSDK_CPPRetimerTest\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPRetimerTest

ViconDataStreamSDK_CPPTest:
	@echo \[1\;31mBuilding ViconDataStreamSDK_CPPTest\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CPPTest

ViconDataStreamSDK_CTest:
	@echo \[1\;31mBuilding ViconDataStreamSDK_CTest\[0m
	@$(MAKE) CONFIG=$(CONFIG) -C Vicon/CrossMarket/DataStream/ViconDataStreamSDK_CTest

clean:
	@echo \[1\;31mCleaning $(CONFIG) build\[0m
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
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_C
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPP
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPPRetimerTest
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CPPTest
	rm -f bin/$(CONFIG)/ViconDataStreamSDK_CTest

distclean:
	@echo \[1\;31mCleaning all builds\[0m
	find . \( -name '*.[od]' -o -name '*.gch' \) -exec rm -f {} ';' 
	find . -name 'moc_*.cxx' -exec rm -f {} ';' 
	rm -rf lib 
	rm -rf bin 
