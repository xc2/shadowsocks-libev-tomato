# -*- mode: makefile -*-
CACHEROOT := $(HOME)/CACHE
TMPDIR := $(shell dirname $(shell mktemp -u))
NPROCS := $(shell nproc)
GNUPGHOME := $(shell mktemp --tmpdir -u -d gnupg.XXXXXXXXX)
GPG := GNUPGHOME=$(GNUPGHOME) gpg --batch --no -v

include toolchain.mk
include libpcre.mk
include libcrypto.mk
include libsodium.mk
include libudns.mk
include libev.mk

SHADOWSOCKS_LIBEV_VERSION := 3.0.0
SHADOWSOCKS_LIBEV_GIT_REPOSITORY = $(CACHEROOT)/shadowsocks-libev
SHADOWSOCKS_LIBEV_SOURCE := $(shell mktemp -u -d --tmpdir shadowsocks-libev.XXXXXXXXXX)
SHADOWSOCKS_LIBEV_PATCHES := $(wildcard $(PWD)/patch/*.patch)
SHADOWSOCKS_LIBEV_TARGET_DIR := $(HOME)
SHADOWSOCKS_LIBEV_RELEASE_VERSION := $(SHADOWSOCKS_LIBEV_VERSION)
SHADOWSOCKS_LIBEV := shadowsocks-libev-$(SHADOWSOCKS_LIBEV_RELEASE_VERSION)-$(TOOLCHAIN)
SHADOWSOCKS_LIBEV_INSTALL := $(SHADOWSOCKS_LIBEV_TARGET_DIR)/$(SHADOWSOCKS_LIBEV)
SHADOWSOCKS_LIBEV_PACKAGE := $(SHADOWSOCKS_LIBEV_INSTALL).tar.gz
SHADOWSOCKS_LIBEV_CHECKSUM := $(SHADOWSOCKS_LIBEV_INSTALL).sha256sum
SHADOWSOCKS_LIBEV_CHECKSUM_SIG := $(SHADOWSOCKS_LIBEV_INSTALL).sha256sum.sig

package: $(SHADOWSOCKS_LIBEV_PACKAGE) $(SHADOWSOCKS_LIBEV_CHECKSUM) $(SHADOWSOCKS_LIBEV_CHECKSUM_SIG)

compile: $(SHADOWSOCKS_LIBEV_INSTALL)

$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY):
	git clone --recursive https://github.com/shadowsocks/shadowsocks-libev.git "$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY).progress"
	mv "$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY).progress" "$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY)"

$(SHADOWSOCKS_LIBEV_SOURCE): $(SHADOWSOCKS_LIBEV_GIT_REPOSITORY)
	cd "$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY)" && git reset --hard HEAD && git submodule foreach git reset --hard HEAD && git fetch origin && git checkout "v$(SHADOWSOCKS_LIBEV_VERSION)"
	mkdir -p "$(SHADOWSOCKS_LIBEV_SOURCE)" && rsync -a --delete --delete-after --exclude=".git" "$(SHADOWSOCKS_LIBEV_GIT_REPOSITORY)/" "$(SHADOWSOCKS_LIBEV_SOURCE)/"

$(SHADOWSOCKS_LIBEV_INSTALL): $(SHADOWSOCKS_LIBEV_TARBALL) $(TOOLCHAIN_INSTALL) $(PCRE_INSTALL) $(SODIUM_INSTALL) $(UDNS_INSTALL) $(LIBEV_INSTALL) $(SHADOWSOCKS_LIBEV_SOURCE)
	(cd "$(SHADOWSOCKS_LIBEV_SOURCE)" && $(foreach patchfile,$(SHADOWSOCKS_LIBEV_PATCHES),patch -p1 < $(patchfile) &&) echo patched)
	(\
cd "$(SHADOWSOCKS_LIBEV_SOURCE)" && ./autogen.sh && \
$(MKFLAGS) $(MKENV) LIBS="$(LIBS) -lm -pthread" \
LDFLAGS="$(LDFALGS) $(LIBUDNS_LDFLAGS) $(LIBEV_LDFLAGS)" \
CPPFLAGS="$(CPPFLAGS) $(LIBUDNS_CPPFLAGS) $(LIBEV_CPPFLAGS)" ./configure \
--host=$(HOST_COMPILER) --prefix=$(SHADOWSOCKS_LIBEV_INSTALL) \
--disable-ssp --disable-dependency-tracking --disable-documentation --disable-shared --enable-static \
--with-pcre=$(PCRE_INSTALL) --with-sodium=$(SODIUM_INSTALL) \
--with-$(CRYPTO_LIBRARY)="$(LIBCRYPTO_INSTALL)" && \
$(MKFLAGS) make -j$(NPROCS) && make install \
)
	(cd "$(TMPDIR)" && rm -rf shadowsocks-libev.*)

$(SHADOWSOCKS_LIBEV_PACKAGE): $(SHADOWSOCKS_LIBEV_INSTALL)
	(\
cd "$(SHADOWSOCKS_LIBEV_TARGET_DIR)" && \
tar zcvf "$(SHADOWSOCKS_LIBEV_PACKAGE).progress" "$(SHADOWSOCKS_LIBEV)" && \
mv "$(SHADOWSOCKS_LIBEV_PACKAGE).progress" "$(SHADOWSOCKS_LIBEV_PACKAGE)" \
)

$(SHADOWSOCKS_LIBEV_CHECKSUM): $(SHADOWSOCKS_LIBEV_PACKAGE) $(SHADOWSOCKS_LIBEV_INSTALL)
	(\
cd "$(SHADOWSOCKS_LIBEV_TARGET_DIR)" && \
sha256sum -b `basename $(SHADOWSOCKS_LIBEV_PACKAGE)` `find $(SHADOWSOCKS_LIBEV) -type f` > "$(SHADOWSOCKS_LIBEV_CHECKSUM).progress" && \
mv "$(SHADOWSOCKS_LIBEV_CHECKSUM).progress" "$(SHADOWSOCKS_LIBEV_CHECKSUM)" \
)

$(SHADOWSOCKS_LIBEV_CHECKSUM_SIG): $(SHADOWSOCKS_LIBEV_CHECKSUM)
	mkdir -p "$(GNUPGHOME)"
	chmod 700 "$(GNUPGHOME)"
	$(GPG) --import ./.priv/F84FC08D.key
	$(GPG) --default-key F84FC08D -a --textmode -o $(SHADOWSOCKS_LIBEV_CHECKSUM_SIG) --clearsign $(SHADOWSOCKS_LIBEV_CHECKSUM)
	cat "$(SHADOWSOCKS_LIBEV_CHECKSUM_SIG)"
	(cd "$(TMPDIR)" && rm -rf gnupg.*)

.PHONY: package compile
