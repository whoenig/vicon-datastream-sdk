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
    # $(warning setting PROCESSOR to i686)
    PROCESSOR=i686
  endif
endif

# We inherit our C++ compiler from the environment variable $(CXX)
# since the system default compiler is often rather elderly.
# If this variable is not set, the system default compiler will be used.
#CXX=g++


# If the compiler is set of the icc (the Intel C++ Compiler) then 
# modify warnings and linker variables
ifeq  ($(CXX), icc)
  CXXWARN=
  CCWARN=
  LD=icc -lstdc++
else 
  # todo: append ' -Wno-delete-non-virtual-dtor' for g++ 4.7 and above.
  CXXWARN=-Wall -Wno-sign-compare -Wno-unknown-pragmas -Wno-parentheses -Winvalid-pch -Wno-unused-variable -Wno-reorder -Wno-unused-but-set-variable -Wno-unused-function -Wno-deprecated-declarations
  CCWARN=-Wall -Wno-sign-compare -Wno-unknown-pragmas -Wno-parentheses -Winvalid-pch
  LD=$(CXX)
endif

SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk 

# ENV_CPU is the cpu value specified in the Environment.xml file 
# for OSX, this is used to indicate the architecture of the executable to be built
# x86  maps to i386
# x64  maps to x86_65
# intel maps to i386 and x86_64  
#

OSX_FLAGS_DEFAULT=-mmacosx-version-min=10.9 -isysroot ${SDK}
ifeq ($(ENV_CPU), x86)
  OSX_FLAGS=${OSX_FLAGS_DEFAULT} -arch i386 
else ifeq ($(ENV_CPU), x64)
  OSX_FLAGS=${OSX_FLAGS_DEFAULT} -arch x86_64
else ifeq ($(ENV_CPU), intel)
  OSX_FLAGS=${OSX_FLAGS_DEFAULT} -arch i386 -arch x86_64
endif

CXXFLAGS_OSX=${OSX_FLAGS} -std=c++11 -stdlib=libc++
CCFLAGS_OSX=${OSX_FLAGS}
LDFLAGS_OSX=${OSX_FLAGS} -Wl,-syslibroot,${SDK}

ifeq ($(ARCH),arm)
  ifeq ($(CXX),)
      CXX=arm-none-linux-gnueabi-g++
  endif
  CC=$(CXX)
  LD=$(CXX)
  CXXFLAGS_Debug=-g -fvisibility=hidden -fvisibility-inlines-hidden $(CXXWARN)
  CXXFLAGS_InternalRelease=-O2 -fno-strict-aliasing -g -fvisibility=hidden -fvisibility-inlines-hidden $(CXXWARN)
  CXXFLAGS_Release=-O2 -fno-strict-aliasing -fvisibility=hidden -fvisibility-inlines-hidden $(CXXWARN)
  CCFLAGS_Debug=-g -fvisibility=hidden $(CCWARN)
  CCFLAGS_InternalRelease=-O2 -fno-strict-aliasing -g -fvisibility=hidden $(CCWARN)
  CCFLAGS_Release=-O2 -fvisibility=hidden -fno-strict-aliasing -fvisibility=hidden $(CCWARN)
else
# dpcdpc - Add Pentium4 specifier to Debug/InternalRelease builds in order 
# to get interlock intrinsics required by UtilsThreading/Interlock.h
# dpcdpc - Note that fpmath=sse is the default on x86-64
ifeq ($(ARCH),Linux)
  # gcc-4.7 doesn't define _GLIBCXX_HAVE_GTHR_DEFAULT, which then breaks
  # boost-1.38. e.g. see https://svn.boost.org/trac/boost/ticket/6165. So we
  # define it on the command line with -D.
  CXXFLAGS_Base = -fvisibility=hidden -fvisibility-inlines-hidden -fno-strict-aliasing -D_GLIBCXX_HAVE_GTHR_DEFAULT -D_GLIBCXX_USE_CXX11_ABI=0 $(CXXWARN)
  ifeq ($(PROCESSOR),x86_64)
    CXXFLAGS_Base += -m64 -march=core2
    CXXFLAGS_Debug            = $(CXXFLAGS_Base) -g
    CXXFLAGS_InternalRelease  = $(CXXFLAGS_Base) -g -O2
    CXXFLAGS_Release          = $(CXXFLAGS_Base) -O2 -mfpmath=sse -msse2
  else
    CXXFLAGS_Base += -m32 -march=core2
    CXXFLAGS_Debug            = $(CXXFLAGS_Base) -g
    CXXFLAGS_InternalRelease  = $(CXXFLAGS_Base) -g -O2
    CXXFLAGS_Release          = $(CXXFLAGS_Base) -O2 -mfpmath=sse -msse2
  endif
  CCFLAGS_Debug           = $(CXXFLAGS_Debug)
  CCFLAGS_InternalRelease = $(CXXFLAGS_InternalRelease)
  CCFLAGS_Release         = $(CXXFLAGS_Release)
else
ifeq ($(ARCH),Darwin) 
  CXXFLAGS_Debug=$(CXXFLAGS_OSX) -g $(CXXWARN) 
  CXXFLAGS_InternalRelease=$(CXXFLAGS_OSX) -O2 -g $(CXXWARN) 
  CXXFLAGS_Release=$(CXXFLAGS_OSX) -O2 $(CXXWARN) 
  CCFLAGS_Debug=$(CCFLAGS_OSX) -g $(CCWARN) 
  CCFLAGS_InternalRelease=$(CCFLAGS_OSX) -O2 -g $(CCWARN) 
  CCFLAGS_Release=$(CCFLAGS_OSX) -O2 $(CCWARN) 

  #
  # the QuickTime framework is not available on Mac OS X in a 64-bit flavour
  #
  ifeq ($(ENV_CPU),x86)
    L_FRAMEWORKS=-framework IOKit -framework Python -framework Accelerate -framework AGL -framework OpenGL -framework Carbon -framework QuickTime -framework AppKit -framework ApplicationServices
  else
    L_FRAMEWORKS=-framework IOKit -framework Python -framework Accelerate -framework AGL -framework OpenGL -framework Carbon -framework AppKit -framework ApplicationServices
  endif

else
ifeq ($(ARCH),NDKarmv7a) 
  CXXFLAGS_Base = -march=armv7-a -mfloat-abi=softfp -mfpu=vfp -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -mthumb -Wno-psabi $(CXXWARN)
  CXXFLAGS_Debug=$(CXXFLAGS_Base) -g
  CXXFLAGS_InternalRelease=$(CXXFLAGS_Base) -O2 -g
  CXXFLAGS_Release=$(CXXFLAGS_Base) -O2
  CCFLAGS_Debug = $(CXXFLAGS_Debug)
  CCFLAGS_InternalRelease = $(CXXFLAGS_InternalRelease)
  CCFLAGS_Release = $(CXXFLAGS_Release)
else
  CXXFLAGS_Debug=-g $(CXXWARN)
  CXXFLAGS_InternalRelease=-O -g $(CXXWARN)
  CXXFLAGS_Release=-O $(CXXWARN)
  CCFLAGS_Debug=-g $(CCWARN)
  CCFLAGS_InternalRelease=-O -g $(CCWARN)
  CCFLAGS_Release=-O $(CCWARN)
endif
endif
endif
endif



ifeq ($(ARCH),Darwin)
  LDFLAGS_Debug=$(LDFLAGS_OSX)
  LDFLAGS_InternalRelease=$(LDFLAGS_OSX)
  LDFLAGS_Release=$(LDFLAGS_OSX)

endif

ifeq ($(ARCH),arm)
  # We want to build Pico stuff statically and that happens to be the only thing we build for ARM.  If we had other ARM-based
  # products we might need to do something smarter.
  LDFLAGS_Debug=-static
  LDFLAGS_InternalRelease=-static
  LDFLAGS_Release=-static
endif

ifeq ($(ARCH),Linux)
  ifeq ($(PROCESSOR),x86_64)
    LDFLAGS_Debug=-m64
    LDFLAGS_InternalRelease=-m64
    LDFLAGS_Release=-m64
  else
    LDFLAGS_Debug=-m32
    LDFLAGS_InternalRelease=-m32
    LDFLAGS_Release=-m32
  endif
endif


ifeq ($(ARCH),NDKarmv7a)
  LDFLAGS_Debug=
  LDFLAGS_InternalRelease=
  LDFLAGS_Release=
endif

L_INCLUDEPATHS=$(INCLUDEPATHS:%=-I%)
L_LIBRARYPATHS=$(LIBRARYPATHS:%=-L%)
L_DEPENDENCIES=$(DEPENDENCIES:%=-l%)
L_LIBRARIES=$(LIBRARIES:%=-l%)
L_DEFINES=$(DEFINES:%=-D%)
L_INCLUDES=$(INCLUDES:%=-include %)

L_INCLUDEPATHS_$(CONFIG)=$(INCLUDEPATHS_$(CONFIG):%=-I%)
L_LIBRARYPATHS_$(CONFIG)=$(LIBRARYPATHS_$(CONFIG):%=-L%)
L_LIBRARIES_$(CONFIG)=$(LIBRARIES_$(CONFIG):%=-l%)
L_DEFINES_$(CONFIG)=$(DEFINES_$(CONFIG):%=-D%)
