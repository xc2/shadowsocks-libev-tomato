# -*- mode: makefile -*-
UDNS_VERSION := 0.4
UDNS_TARBALL = $(CACHEROOT)/libudns-$(UDNS_VERSION).tar.gz
UDNS_INSTALL = $(CACHEROOT)/libudns-$(UDNS_VERSION)-$(TOOLCHAIN)
UDNS_SOURCE_DIR := $(shell mktemp -d -u --tmpdir libudns.XXXXXXXXX)
LIBUDNS_LDFLAGS = "-L$(UDNS_INSTALL)/lib"
LIBUDNS_CPPFLAGS = "-I$(UDNS_INSTALL)/include"

$(UDNS_TARBALL):
	wget --continue -O "$(UDNS_TARBALL).wget" "http://www.corpit.ru/mjt/udns/udns-$(UDNS_VERSION).tar.gz"
	mv "$(UDNS_TARBALL).wget" "$(UDNS_TARBALL)"

$(UDNS_INSTALL): $(UDNS_TARBALL) $(TOOLCHAIN_INSTALL)
	mkdir -p "$(UDNS_SOURCE_DIR)"
	tar zxf "$(UDNS_TARBALL)" -C "$(UDNS_SOURCE_DIR)" --strip-components 1
	(\
cd "$(UDNS_SOURCE_DIR)" && \
sed -i 's/^ac_run() {/ac_run() {\nreturn 0/' configure.lib && \
$(MKFLAGS) $(MKENV) ./configure --enable-ipv6 && \
$(MKFLAGS) make -j$(NPROCS) static && mkdir -p install.d/lib install.d/include && \
cp -f libudns* install.d/lib/ && cp -f udns.h install.d/include/ && \
mkdir -p "$(UDNS_INSTALL)" && mv -T install.d "$(UDNS_INSTALL)" \
)
	(cd "$(TMPDIR)" && rm -rf libudns.*)
