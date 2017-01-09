# -*- mode: makefile -*-
TOOLCHAIN_INSTALL = $(CACHEROOT)/hndtools-mipsel-uclibc-4.2.4
CC = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-gcc
CXX = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-g++
LD = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ld
RANLIB = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ranlib
AR = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ar
NM = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-nm
STRIP = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-strip
LDFLAGS = "-L$(TOOLCHAIN_INSTALL)/usr/lib -L$(TOOLCHAIN_INSTALL)/lib -Wl,-rpath=$(TOOLCHAIN_INSTALL)/lib"
CPPFLAGS = -I$(TOOLCHAIN_INSTALL)/include
ARCH = mips
MIPS_ARCH := mips32
CFLAGS = "-Wno-error -Os -march=$(MIPS_ARCH)"
HOST_COMPILER = mipsel-linux

$(TOOLCHAIN_INSTALL): $(MERLIN_TARBALL)
	mkdir -p "$(TOOLCHAIN_INSTALL).work"
	tar zxf $(MERLIN_TARBALL) -C "$(TOOLCHAIN_INSTALL).work" --wildcards --strip-components 5 '*/tools/brcm/K26/hndtools-mipsel-uclibc-4.2.4'
	mv "$(TOOLCHAIN_INSTALL).work" "$(TOOLCHAIN_INSTALL)"
