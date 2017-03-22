PATCHES = $(wildcard $(PWD)/patch/*.patch)
SOURCE := $(shell mktemp -u -d --tmpdir $(PACKAGE_NAME).XXXXXXXXXX)


$(GIT_REPO):
	git clone --recursive https://github.com/shadowsocks/shadowsocks-libev.git "$(GIT_REPO).progress"
	rm -rf "$(GIT_REPO)" && mv "$(GIT_REPO).progress" "$(GIT_REPO)"

$(SOURCE): $(GIT_REPO)
	(cd "$(GIT_REPO)" && git reset --hard HEAD && git submodule foreach git reset --hard HEAD && git fetch origin && git checkout "v$(VERSION)" && git submodule update --init)
	mkdir -p "$(SOURCE).progress"
	rsync -a --delete --delete-after --exclude=".git" "$(GIT_REPO)/" "$(SOURCE).progress/"
	(cd "$(SOURCE).progress" && $(foreach patchfile,$(PATCHES),patch -p1 < $(patchfile) &&) echo patched)
	rm -rf "$(SOURCE)"
	mv "$(SOURCE).progress" "$(SOURCE)"

$(PACKAGE_PATH): $(SOURCE) $(TOOLCHAIN_INSTALL) $(LIBCRYPTO_INSTALL) $(PCRE_INSTALL) $(SODIUM_INSTALL) $(UDNS_INSTALL) $(LIBEV_INSTALL)
	(cd "$(SOURCE)" && ./autogen.sh && \
$(MKFLAGS) \
$(MKENV) \
LIBS="$(LIBS) -lm -pthread" \
LDFLAGS="$(LDFALGS) $(LIBUDNS_LDFLAGS) $(LIBEV_LDFLAGS)" \
CPPFLAGS="$(CPPFLAGS) $(LIBUDNS_CPPFLAGS) $(LIBEV_CPPFLAGS)" \
./configure \
--host=$(HOST_COMPILER) \
--prefix=$(PACKAGE_PATH) \
--disable-ssp \
--disable-dependency-tracking \
--disable-documentation \
--disable-shared \
--enable-static \
--with-pcre=$(PCRE_INSTALL) \
--with-sodium=$(SODIUM_INSTALL) \
--with-$(CRYPTO_LIBRARY)="$(LIBCRYPTO_INSTALL)" && \
$(MKFLAGS) make -j$(NPROCS) && make install \
)
	(cd "$(TMPDIR)" && rm -rf "$(SOURCE)")

$(PACKAGE_TARBALL): $(PACKAGE_PATH)
	(\
cd "$(TARGET_DIR)" && \
tar zcvf "$(PACKAGE_TARBALL).progress" "$(PACKAGE_TARBALL)" && \
mv "$(PACKAGE_TARBALL).progress" "$(PACKAGE_TARBALL)" \
)


