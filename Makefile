# -*- mode: makefile -*-
CACHEROOT := $(HOME)/CACHE
TMPDIR := $(shell dirname $(shell mktemp -u))
SHADOWSOCKS_LIBEV_VERSION := 2.5.6
SHADOWSOCKS_LIBEV_TARBALL = $(CACHEROOT)/shadowsocks-libev-$(SHADOWSOCKS_LIBEV_VERSION).tar.gz
SHADOWSOCKS_LIBEV_SOURCE := $(shell mktemp -u -d --tmpdir shadowsocks-libev.XXXXXXXXXX)
SHADOWSOCKS_LIBEV_INSTALL := $(HOME)/shadowsocks-libev
SHADOWSOCKS_LIBEV_PATCHES := $(wildcard $(PWD)/patch/*.patch)

$(CACHEROOT):
	mkdir -p "$(CACHEROOT)"

include toolchain.mk
include libz.mk
include libpcre.mk
include libcrypto.mk

install: $(SHADOWSOCKS_LIBEV_INSTALL)

$(SHADOWSOCKS_LIBEV_TARBALL):
	wget --continue -O "$(SHADOWSOCKS_LIBEV_TARBALL).wget" "https://github.com/shadowsocks/shadowsocks-libev/archive/v$(SHADOWSOCKS_LIBEV_VERSION).tar.gz"
	mv "$(SHADOWSOCKS_LIBEV_TARBALL).wget" "$(SHADOWSOCKS_LIBEV_TARBALL)"

$(SHADOWSOCKS_LIBEV_SOURCE): $(SHADOWSOCKS_LIBEV_TARBALL)
	mkdir -p "$(SHADOWSOCKS_LIBEV_SOURCE)"
	tar zxf "$(SHADOWSOCKS_LIBEV_TARBALL)" --strip-components 1 -C "$(SHADOWSOCKS_LIBEV_SOURCE)"

$(SHADOWSOCKS_LIBEV_INSTALL): $(SHADOWSOCKS_LIBEV_SOURCE) toolchain libz libpcre libcrypto
	(cd "$(SHADOWSOCKS_LIBEV_SOURCE)" && $(foreach patchfile,$(SHADOWSOCKS_LIBEV_PATCHES),patch -p1 < $(patchfile)))
	(\
cd "$(SHADOWSOCKS_LIBEV_SOURCE)" && \
$(MKENV) ./configure --host=$(CROSS_HOST) --prefix=$(SHADOWSOCKS_LIBEV_INSTALL) \
--disable-ssp --disable-dependency-tracking --disable-shared --enable-static --disable-documentation \
--with-pcre=$(PCRE_INSTALL) --with-zlib=$(ZLIB_INSTALL) \
--with-crypto-library=$(CRYPTO_LIBRARY) --with-$(CRYPTO_LIBRARY)=$(LIBCRYPTO_INSTALL) &&\
make && make install \
)
	(cd "$(TMPDIR)" && rm -rf shadowsocks-libev.*)

.PHONY: install toolchain libz libpcre libcrypto
