# -*- mode: makefile -*-
OPENSSL_VERSION := 1.0.1u
OPENSSL_TARBALL = $(CACHEROOT)/openssl-$(OPENSSL_VERSION).tar.gz
OPENSSL_INSTALL = $(CACHEROOT)/openssl-$(OPENSSL_VERSION)-$(TOOLCHAIN)
OPENSSL_SOURCE_DIR := $(shell mktemp -d -u --tmpdir openssl.XXXXXXXXXX)
LIBCRYPTO_INSTALL = $(OPENSSL_INSTALL)

$(OPENSSL_TARBALL):
	wget --continue -O "$(OPENSSL_TARBALL).wget" "https://www.openssl.org/source/openssl-$(OPENSSL_VERSION).tar.gz"
	mv "$(OPENSSL_TARBALL).wget" "$(OPENSSL_TARBALL)"

$(OPENSSL_INSTALL): $(OPENSSL_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(OPENSSL_SOURCE_DIR)"
	tar zxf "$(OPENSSL_TARBALL)" -C "$(OPENSSL_SOURCE_DIR)" --strip-components 1
	(\
cd "$(OPENSSL_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./Configure no-shared --prefix="$(OPENSSL_INSTALL)" enable-tlsext os/compiler:$(HOST_COMPILER)-gcc && \
$(MKFLAGS) make AR=$(AR)\ rcv -j $(NPROCS) -f Makefile all && make install\
)
	(cd "$(TMPDIR)" && rm -rf openssl.*)
