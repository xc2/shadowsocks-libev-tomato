# -*- mode: makefile -*-
CARES_VERSION := 1.12.0
CARES_TARBALL = $(CACHEROOT)/cares-$(CARES_VERSION).tar.gz
CARES_INSTALL = $(CACHEROOT)/cares-$(CARES_VERSION)-$(TOOLCHAIN)
CARES_SOURCE_DIR := $(shell mktemp -d -u --tmpdir cares.XXXXXXXXXX)
CARES_LDFLAGS = "-L$(CARES_INSTALL)/lib"
CARES_CPPFLAGS = "-I$(CARES_INSTALL)/include"

$(CARES_TARBALL):
	wget --continue -O "$(CARES_TARBALL).wget" "https://c-ares.haxx.se/download/c-ares-$(CARES_VERSION).tar.gz"
	mv "$(CARES_TARBALL).wget" "$(CARES_TARBALL)"

$(CARES_INSTALL): $(CARES_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(CARES_SOURCE_DIR)"
	tar zxf "$(CARES_TARBALL)" -C "$(CARES_SOURCE_DIR)" --strip-components 1
	(\
cd "$(CARES_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./configure --host="$(HOST_COMPILER)" --prefix="$(CARES_INSTALL)" --disable-dependency-tracking --enable-static --disable-shared && \
$(MKFLAGS) make -j$(NPROCS) && make install\
)
	(cd "$(TMPDIR)" && rm -rf cares.*)
