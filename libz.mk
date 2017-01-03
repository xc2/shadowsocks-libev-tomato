# -*- mode: makefile -*-
ZLIB_VERSION := 1.2.10
ZLIB_TARBALL = $(CACHEROOT)/zlib-$(ZLIB_VERSION).tar.gz
ZLIB_INSTALL = $(CACHEROOT)/zlib-$(ZLIB_VERSION)-$(TOOLCHAIN)
ZLIB_SOURCE_DIR := $(shell mktemp -d -u --tmpdir zlib.XXXXXXXXX)

$(ZLIB_TARBALL):
	wget --continue -O "$(ZLIB_TARBALL).wget" "http://zlib.net/zlib-$(ZLIB_VERSION).tar.gz"
	mv "$(ZLIB_TARBALL).wget" "$(ZLIB_TARBALL)"

$(ZLIB_INSTALL): $(ZLIB_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(ZLIB_SOURCE_DIR)"
	tar zxf "$(ZLIB_TARBALL)" -C "$(ZLIB_SOURCE_DIR)" --strip-components 1
	(\
cd "$(ZLIB_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./configure --static --prefix="$(ZLIB_INSTALL)" && \
$(MKFLAGS) make -j$(NPROCS) && make install\
)
	(cd "$(TMPDIR)" && rm -rf zlib.*)
