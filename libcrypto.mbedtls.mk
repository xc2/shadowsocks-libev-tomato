# -*- mode: makefile -*-
MBEDTLS_VERSION := 2.4.0-gpl
MBEDTLS_TARBALL = $(CACHEROOT)/mbedtls-$(MBEDTLS_VERSION).tar.gz
MBEDTLS_INSTALL = $(CACHEROOT)/mbedtls-$(MBEDTLS_VERSION)-$(TOOLCHAIN)
MBEDTLS_SOURCE_DIR := $(shell mktemp -d -u --tmpdir mbedtls.XXXXXXXXXX)
LIBCRYPTO_INSTALL = $(MBEDTLS_INSTALL)

$(MBEDTLS_TARBALL):
	wget --continue -O "$(MBEDTLS_TARBALL).wget" "https://tls.mbed.org/download/mbedtls-$(MBEDTLS_VERSION).tgz"
	mv "$(MBEDTLS_TARBALL).wget" "$(MBEDTLS_TARBALL)"

$(MBEDTLS_INSTALL): $(MBEDTLS_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(MBEDTLS_SOURCE_DIR)"
	tar zxf "$(MBEDTLS_TARBALL)" -C "$(MBEDTLS_SOURCE_DIR)" --strip-components 1
	(cd "$(MBEDTLS_SOURCE_DIR)" && $(MKFLAGS) make $(MKENV) -j$(NPROCS) && make DESTDIR="$(MBEDTLS_INSTALL)" install)
	(cd "$(TMPDIR)" && rm -rf mbedtls.*)
