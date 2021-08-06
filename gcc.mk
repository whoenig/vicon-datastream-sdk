# Stock options for GCC

# Only set things from uname if not already defined.  Note that 'make foo=3'
# will ensure that 'foo' is not overridded inside the makefile, but 'foo=3
# make' does not.

ifeq ($(ARCH),)
    ARCH=$(shell uname -s)
endif

ifeq ($(PROCESSOR),)
    PROCESSOR=$(shell uname -m)
endif

ifneq ($(VICON_BUILD_x32),)
  ifeq ($(ARCH),x86_64)
    PROCESSOR=i686
  endif
endif

# gcc 8.0 onwards provided full support for c++17
CXX_VERSION_8_0 := $(shell echo `$(CXX) -dumpversion | cut -f1-2 -d.` \>= 8.0 | bc)
# gcc 5.0 onwards provided full support for c++14
CXX_VERSION_5_0 := $(shell echo `$(CXX) -dumpversion | cut -f1-2 -d.` \>= 5.0 | bc)
# gcc 4.8 no unused local typedefs warning
CXX_VERSION_4_8 := $(shell echo `$(CXX) -dumpversion | cut -f1-2 -d.` \>= 4.8 | bc)
# gcc 4.7 non-virtual destructor warning
CXX_VERSION_4_7 := $(shell echo `$(CXX) -dumpversion | cut -f1-2 -d.` \>= 4.7 | bc)

CXX_WARNINGS=-Wall -Wno-sign-compare -Wno-unknown-pragmas -Wno-parentheses -Winvalid-pch -Wno-unused-variable -Wno-reorder -Wno-unused-but-set-variable -Wno-unused-function -Wno-deprecated-declarations -Wno-attributes

ifeq ($(CXX_VERSION_4_8),1)
  CXX_WARNINGS+=-Wno-unused-local-typedefs
endif

ifeq ($(CXX_VERSION_4_7),1)
  CXX_WARNINGS+=-Wno-delete-non-virtual-dtor
endif

CC_WARNINGS=-Wall -Wno-sign-compare -Wno-unknown-pragmas -Wno-parentheses -Winvalid-pch -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-function -Wno-deprecated-declarations

# Define the c++ language standard
ifeq ($(ARCH),Darwin)
  # On MacOSX XCode lies and uses clang as gcc so the version number is incorrect,
  # We should verify the clang version number or just use clang directly for MacOSX builds.
  CXX_STANDARD=-std=c++17
else ifeq ($(CXX_VERSION_8_0),1)
  # Use full c++17 support, note this may be overridden by the 'CppStandard14' project option
  CXX_STANDARD=-std=c++17
else ifeq ($(CXX_VERSION_5_0),1)
  # Try experimental c++17 support instead, most gcc version had good support for c++17 early on.
  CXX_STANDARD=-std=c++1z
else
  # Worst case scenario, fallback to early c++14 support, the minimum standard our libraries require is c++14.
  CXX_STANDARD=-std=c++1y
endif

# Compiler flags
ifeq ($(CONFIG), Debug)
  COMMON_FLAGS=-g
else ifeq ($(CONFIG), InternalRelease)
  COMMON_FLAGS=-g -O2
else ifeq ($(CONFIG), Release)
  COMMON_FLAGS=-O2
endif

ifeq ($(ARCH),Linux)
  COMMON_FLAGS+=-fvisibility=hidden -fno-strict-aliasing
  ifeq ($(PROCESSOR),x86_64)
    COMMON_FLAGS+=-m64
  else
    COMMON_FLAGS+=-m32
  endif

  ifeq ($(CONFIG), Release)
    COMMON_FLAGS+=-mfpmath=sse -msse2
  endif

  CCFLAGS=$(COMMON_FLAGS) $(CC_WARNINGS)
  CXXFLAGS=$(COMMON_FLAGS) $(CXX_STANDARD) -fvisibility-inlines-hidden -D_GLIBCXX_HAVE_GTHR_DEFAULT -D_GLIBCXX_USE_CXX11_ABI=0 $(CXX_WARNINGS)

else ifeq ($(ARCH),Darwin)
  MACOSX_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk

  MACOSX_FLAGS+=-mmacosx-version-min=10.9 -isysroot ${MACOSX_SDK}

  # ENV_CPU is the cpu value specified in the Environment.xml file.
  # For OSX, this is used to indicate the architecture of the executable to be built:
  # x86 - maps to i386
  # x64 - maps to x86_65
  # intel - maps to i386 and x86_64
  ifeq ($(ENV_CPU), x86)
    MACOSX_FLAGS+=-arch i386
  else ifeq ($(ENV_CPU), x64)
    MACOSX_FLAGS+=-arch x86_64
  else ifeq ($(ENV_CPU), intel)
    MACOSX_FLAGS+=-arch i386 -arch x86_64
  endif

  CCFLAGS=$(MACOSX_FLAGS) $(COMMON_FLAGS) $(CC_WARNINGS)
  CXXFLAGS=$(MACOSX_FLAGS) $(COMMON_FLAGS) $(CXX_STANDARD) -stdlib=libc++ $(CXX_WARNINGS)

else ifeq ($(ARCH),arm)
  ifeq ($(CXX),)
    CXX=arm-none-linux-gnueabi-g++
  endif
  CC=$(CXX)

  COMMON_FLAGS+=-fno-strict-aliasing -g -fvisibility=hidden -fvisibility-inlines-hidden

  CCFLAGS=$(COMMON_FLAGS) $(CC_WARNINGS)
  CXXFLAGS=$(COMMON_FLAGS) $(CXX_STANDARD) $(CXX_WARNINGS)

else ifeq ($(ARCH),NDKarmv7a)
  COMMON_FLAGS=-march=armv7-a -mfloat-abi=softfp -mfpu=vfp -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -mthumb -Wno-psabi

  CCFLAGS=$(COMMON_FLAGS) $(CC_WARNINGS)
  CXXFLAGS=$(COMMON_FLAGS) $(CXX_STANDARD) $(CXX_WARNINGS)

else
  CCFLAGS=$(COMMON_FLAGS) $(CC_WARNINGS)
  CXXFLAGS=$(COMMON_FLAGS) $(CXX_STANDARD) $(CXX_WARNINGS)

endif

# Linker flags
LD=$(CXX)

ifeq ($(ARCH),Linux)
  ifeq ($(PROCESSOR),x86_64)
    LDFLAGS=-m64
  else
    LDFLAGS=-m32
  endif

else ifeq ($(ARCH),Darwin)
  LDFLAGS=$(MACOSX_FLAGS)

else ifeq ($(ARCH),arm)
  # We want to build Pico stuff statically and that happens to be the only thing we build for ARM.  If we had other ARM-based
  # products we might need to do something smarter.
  LDFLAGS=-static

endif

# define the frameworks used on MacOSX
ifeq ($(ARCH),Darwin)
  L_FRAMEWORKS=-framework IOKit -framework Python -framework Accelerate -framework AGL -framework OpenGL -framework Carbon -framework AppKit -framework ApplicationServices
  # the QuickTime framework is not available on Mac OS X in a 64-bit flavour
  ifeq ($(ENV_CPU),x86)
    L_FRAMEWORKS+=-framework QuickTime
  endif
endif