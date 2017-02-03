# -*- mode: makefile -*-
LIBEV_VERSION := 4.24
LIBEV_TARBALL = $(CACHEROOT)/libev-$(LIBEV_VERSION).tar.gz
LIBEV_INSTALL = $(CACHEROOT)/libev-$(LIBEV_VERSION)-$(TOOLCHAIN)
LIBEV_SOURCE_DIR := $(shell mktemp -d -u --tmpdir libev.XXXXXXXXX)
LIBEV_LDFLAGS = "-L$(LIBEV_INSTALL)/lib"
LIBEV_CPPFLAGS = "-I$(LIBEV_INSTALL)/include"

$(LIBEV_TARBALL):
	wget --continue -O "$(LIBEV_TARBALL).wget" "http://dist.schmorp.de/libev/Attic/libev-$(LIBEV_VERSION).tar.gz"
	mv "$(LIBEV_TARBALL).wget" "$(LIBEV_TARBALL)"

$(LIBEV_INSTALL): $(LIBEV_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(LIBEV_SOURCE_DIR)"
	tar zxf "$(LIBEV_TARBALL)" -C "$(LIBEV_SOURCE_DIR)" --strip-components 1
	(\
cd "$(LIBEV_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./configure --enable-static --disable-shared \
--host="$(HOST_COMPILER)" \
--disable-dependency-tracking --prefix="$(LIBEV_INSTALL)" && \
$(MKFLAGS) make -j$(NPROCS) && make install\
)
	(cd "$(TMPDIR)" && rm -rf libev.*)
