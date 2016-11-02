# -*- mode: makefile -*-
TOOLCHAIN := merlin
include toolchain.$(TOOLCHAIN).mk
toolchain: $(TOOLCHAIN_INSTALL)
MKENV = CC=$(CC) CXX=$(CXX) LD=$(LD) RANLIB=$(RANLIB) AR=$(AR) NM=$(NM) STRIP=$(STRIP) LDFLAGS=$(LDFLAGS)
