# -*- mode: makefile -*-
PCRE_VERSION := 8.41
PCRE_TARBALL = $(CACHEROOT)/pcre-$(PCRE_VERSION).tar.gz
PCRE_INSTALL = $(CACHEROOT)/pcre-$(PCRE_VERSION)-$(TOOLCHAIN)
PCRE_SOURCE_DIR := $(shell mktemp -d -u --tmpdir pcre.XXXXXXXXXX)

$(PCRE_TARBALL):
	wget --continue -O "$(PCRE_TARBALL).wget" "https://ftp.pcre.org/pub/pcre/pcre-$(PCRE_VERSION).tar.gz"
	mv "$(PCRE_TARBALL).wget" "$(PCRE_TARBALL)"

$(PCRE_INSTALL): $(PCRE_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(PCRE_SOURCE_DIR)"
	tar zxf "$(PCRE_TARBALL)" -C "$(PCRE_SOURCE_DIR)" --strip-components 1
	(\
cd "$(PCRE_SOURCE_DIR)" && \
$(MKFLAGS) $(MKENV) ./configure --host="$(HOST_COMPILER)" --prefix="$(PCRE_INSTALL)" --disable-dependency-tracking && \
$(MKFLAGS) make -j$(NPROCS) && make install\
)
	(cd "$(TMPDIR)" && rm -rf pcre.*)
