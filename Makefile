# -*- mode: makefile -*-
include config.mk

package: $(PACKAGE_TARBALL)
compile: $(PACKAGE_PATH)
checksum: $(PACKAGE_TARBALL) $(PACKAGE_PATH)
	(cd "$(TARGET_DIR)" && sha256sum -b `basename $(PACKAGE_TARBALL)` `find $(PACKAGE_TARBALL) -type f`)

include deps/toolchain.mk
include deps/libpcre.mk
include deps/libcrypto.mk
include deps/libsodium.mk
include deps/libudns.mk
include deps/libev.mk
include shadowsocks-libev.mk

.PHONY: package compile checksum