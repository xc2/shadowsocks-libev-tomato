# -*- mode: makefile -*-
PCRE_VERSION := 8.39
PCRE_TARBALL = $(CACHEROOT)/pcre-$(PCRE_VERSION).tar.gz
PCRE_INSTALL = $(CACHEROOT)/pcre-$(PCRE_VERSION)
PCRE_SOURCE_DIR := $(shell mktemp -d -u --tmpdir pcre.XXXXXXXXXX)

$(PCRE_TARBALL):
	wget --continue -O "$(PCRE_TARBALL).wget" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$(PCRE_VERSION).tar.gz"
	mv "$(PCRE_TARBALL).wget" "$(PCRE_TARBALL)"

$(PCRE_INSTALL): $(PCRE_TARBALL)
	mkdir -p "$(PCRE_SOURCE_DIR)"
	tar zxf "$(PCRE_TARBALL)" -C "$(PCRE_SOURCE_DIR)" --strip-components 1
	(\
cd "$(PCRE_SOURCE_DIR)" && \
$(MKENV)  ./configure --host="$(CROSS_HOST)" --prefix="$(PCRE_INSTALL)" --disable-dependency-tracking && \
make install\
)
	(cd "$(TMPDIR)" && rm -rf pcre.*)

libpcre: $(PCRE_INSTALL)
