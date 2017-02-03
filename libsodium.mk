# -*- mode: makefile -*-
SODIUM_VERSION := 1.0.11
SODIUM_TARBALL = $(CACHEROOT)/libsodium-$(SODIUM_VERSION).tar.gz
SODIUM_INSTALL = $(CACHEROOT)/libsodium-$(SODIUM_VERSION)-$(TOOLCHAIN)
SODIUM_SOURCE_DIR := $(shell mktemp -d -u --tmpdir libsodium.XXXXXXXXX)

$(SODIUM_TARBALL):
	wget --continue -O "$(SODIUM_TARBALL).wget" "https://github.com/jedisct1/libsodium/releases/download/$(SODIUM_VERSION)/libsodium-$(SODIUM_VERSION).tar.gz"
	mv "$(SODIUM_TARBALL).wget" "$(SODIUM_TARBALL)"

$(SODIUM_INSTALL): $(SODIUM_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(SODIUM_SOURCE_DIR)"
	tar zxf "$(SODIUM_TARBALL)" -C "$(SODIUM_SOURCE_DIR)" --strip-components 1
	(\
cd "$(SODIUM_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./configure --host=$(HOST_COMPILER) --disable-shared --enable-static --prefix="$(SODIUM_INSTALL)" && \
$(MKFLAGS) make -j$(NPROCS) && make install\
)
	(cd "$(TMPDIR)" && rm -rf libsodium.*)
