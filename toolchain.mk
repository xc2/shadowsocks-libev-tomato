# -*- mode: makefile -*-
TOOLCHAIN := mipsel
MERLIN_VERSION := 380.62_1
MERLIN_TARBALL = $(CACHEROOT)/merlin-$(MERLIN_VERSION).tar.gz

$(MERLIN_TARBALL):
	wget -N --continue -O "$(MERLIN_TARBALL).wget" "https://github.com/RMerl/asuswrt-merlin/archive/$(MERLIN_VERSION).tar.gz"
	mv "$(MERLIN_TARBALL).wget" "$(MERLIN_TARBALL)"

include toolchain.$(TOOLCHAIN).mk

MKENV = CC=$(CC) CXX=$(CXX) LD=$(LD) CCLD=$(LD) CXXLD=$(LD) RANLIB=$(RANLIB) AR=$(AR) NM=$(NM) STRIP=$(STRIP) ARCH=$(ARCH) HOST_COMPILER=$(HOST_COMPILER)
MKFLAGS = LDFLAGS=$(LDFLAGS) CFLAGS=$(CFLAGS) LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
