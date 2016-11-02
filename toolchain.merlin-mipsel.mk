# -*- mode: makefile -*-
MERLIN_VERSION := 380.62_1
MERLIN_TARBALL = $(CACHEROOT)/merlin-$(MERLIN_VERSION).tar.gz
TOOLCHAIN_INSTALL = $(CACHEROOT)/toolchain-merlin-mipsel-uclibc-4.2.4
CC = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-gcc
CXX = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-g++
LD = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ld
RANLIB = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ranlib
AR = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-ar
NM = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-nm
STRIP = $(TOOLCHAIN_INSTALL)/bin/mipsel-linux-strip
LDFLAGS = "-L$(TOOLCHAIN_INSTALL)/usr/lib -L$(TOOLCHAIN_INSTALL)/lib -Wl,-rpath=$(TOOLCHAIN_INSTALL)/lib"
CPPFLAGS = -I$(TOOLCHAIN_INSTALL)/include
CROSS_HOST = mipsel-linux

$(TOOLCHAIN_INSTALL): $(MERLIN_TARBALL)
	mkdir -p "$(TOOLCHAIN_INSTALL).work"
	tar zxf $(MERLIN_TARBALL) -C "$(TOOLCHAIN_INSTALL).work" --wildcards --strip-components 5 '*/tools/brcm/K26/hndtools-mipsel-uclibc-4.2.4'
	mv "$(TOOLCHAIN_INSTALL).work" "$(TOOLCHAIN_INSTALL)"

$(MERLIN_TARBALL):
	wget -N --continue -O "$(MERLIN_TARBALL).wget" "https://github.com/RMerl/asuswrt-merlin/archive/$(MERLIN_VERSION).tar.gz"
	mv "$(MERLIN_TARBALL).wget" "$(MERLIN_TARBALL)"
