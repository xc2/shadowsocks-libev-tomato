# -*- mode: makefile -*-
CRYPTO_LIBRARY := openssl
include libcrypto.$(CRYPTO_LIBRARY).mk
libcrypto: $(LIBCRYPTO_INSTALL)
