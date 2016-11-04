# -*- mode: makefile -*-
POLARSSL_VERSION := 1.2.19-gpl
POLARSSL_TARBALL = $(CACHEROOT)/polarssl-$(POLARSSL_VERSION).tar.gz
POLARSSL_INSTALL = $(CACHEROOT)/polarssl-$(POLARSSL_VERSION)-$(TOOLCHAIN)
POLARSSL_SOURCE_DIR := $(shell mktemp -d -u --tmpdir polarssl.XXXXXXXXXX)
LIBCRYPTO_INSTALL = $(POLARSSL_INSTALL)

$(POLARSSL_TARBALL):
	wget --continue -O "$(POLARSSL_TARBALL).wget" "https://tls.mbed.org/download/polarssl-$(POLARSSL_VERSION).tgz"
	mv "$(POLARSSL_TARBALL).wget" "$(POLARSSL_TARBALL)"

$(POLARSSL_INSTALL): $(POLARSSL_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(POLARSSL_SOURCE_DIR)"
	tar zxf "$(POLARSSL_TARBALL)" -C "$(POLARSSL_SOURCE_DIR)" --strip-components 1
	(cd "$(POLARSSL_SOURCE_DIR)" && $(MKFLAGS) make $(MKENV) -j$(NPROCS) lib && make DESTDIR=$(POLARSSL_INSTALL) install)
	(cd "$(TMPDIR)" && rm -rf polarssl.*)
