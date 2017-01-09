# -*- mode: makefile -*-
TOOLCHAIN_INSTALL = $(CACHEROOT)/hndtools-arm-linux-2.6.36-uclibc-4.5.3
CC = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-gcc
CXX = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-g++
LD = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-ld
RANLIB = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-ranlib
AR = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-ar
NM = $(TOOLCHAIN_INSTALL)/bin/arm-brcm-linux-uclibcgnueabi-nm
STRIP = $(TOOLCHAIN_INSTALL)/bin/arm-uclibc-strip
LDFLAGS = "-L$(TOOLCHAIN_INSTALL)/usr/lib -L$(TOOLCHAIN_INSTALL)/lib -Wl,-rpath=$(TOOLCHAIN_INSTALL)/lib"
CPPFLAGS = -I$(TOOLCHAIN_INSTALL)/include
ARCH = arm
ARM_ARCH := armv7-a
CFLAGS = "-Wno-error -Os -mthumb -marm -march=$(ARM_ARCH)"
HOST_COMPILER = arm-brcm-linux-uclibcgnueabi
LD_LIBRARY_PATH = $(TOOLCHAIN_INSTALL)/lib

$(TOOLCHAIN_INSTALL): $(MERLIN_TARBALL)
	mkdir -p "$(TOOLCHAIN_INSTALL).work"
	tar zxf $(MERLIN_TARBALL) -C "$(TOOLCHAIN_INSTALL).work" --wildcards --strip-components 5 '*/release/src-rt-6.x.4708/toolchains/hndtools-arm-linux-2.6.36-uclibc-4.5.3'
	mv "$(TOOLCHAIN_INSTALL).work" "$(TOOLCHAIN_INSTALL)"
