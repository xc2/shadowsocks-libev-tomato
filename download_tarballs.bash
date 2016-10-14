#!/usr/bin/env bash

# TODO: Check signature

# -* Crypto Library -*-
CRYPTO_LIBRARY_TARBALL="$HOME/$TARBALLS_DIR_TO_HOME/${CRYPTO_LIBRARY}.tar.gz"
if [[ ! -f "$CRYPTO_LIBRARY_TARBALL" ]]; then
  rm -rf "$CRYPTO_LIBRARY_TARBALL"
  case $CRYPTO_LIBRARY in
  openssl-*)
    wget -O "$CRYPTO_LIBRARY_TARBALL" "https://www.openssl.org/source/${CRYPTO_LIBRARY}.tar.gz"
    ;;
  polarssl-*)
    wget -O "$CRYPTO_LIBRARY_TARBALL" "https://tls.mbed.org/download/${CRYPTO_LIBRARY}.tgz"
    ;;
  mbedtls-*)
    wget -O "$CRYPTO_LIBRARY_TARBALL" "https://tls.mbed.org/download/${CRYPTO_LIBRARY}.tgz"
    ;;
  *)
    echo "$CRYPTO_LIBRARY needed." >&2
    exit 1
  esac
fi

# -*- pcre -*-
PCRE_TARBALL="$HOME/$TARBALLS_DIR_TO_HOME/pcre.tar.gz"
[[ -f "$PCRE_TARBALL" ]] || wget -O "$PCRE_TARBALL" "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz"

# -*- pcre -*-
ZLIB_TARBALL="$HOME/$TARBALLS_DIR_TO_HOME/zlib.tar.gz"
[[ -f "$ZLIB_TARBALL" ]] || wget -O "$ZLIB_TARBALL" "http://zlib.net/zlib-1.2.8.tar.gz"

# -*- shadowsocks-libev -*-
SS_TARBALL="$HOME/$TARBALLS_DIR_TO_HOME/source.tar.gz"
[[ -f "$SS_TARBALL" ]] || wget -O "$SS_TARBALL" "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.5.5.tar.gz"
