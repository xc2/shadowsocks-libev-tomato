# Shadowsocks-libev binaries for TomatoUSB mods/forks

[![Build Status](https://travis-ci.org/xc2/shadowsocks-libev-tomato.svg?branch=master)](https://travis-ci.org/xc2/shadowsocks-libev-tomato)

Thanks to [Travis CI](https://travis-ci.org) and Github, I managed to build and host [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) builds for [TomatoUSB](http://tomatousb.org/)-based ROM(eg., [Asuswrt Merlin](https://github.com/RMerl/asuswrt-merlin), [Tomato by shibby](http://tomato.groov.pl/)) continuously.

## What won't this repository do?

You'll not be told how to run these programs, and related issues will be closed with no reply.

## Releases

You can download these binaries from [Release](https://github.com/xc2/shadowsocks-libev-tomato/releases) page of this repository.

Git tags will be signed with GPG key:

- xcxc2 <<xc2@fastmail.com>> [88FDE272AB3188D8](http://pgp.mit.edu/pks/lookup?op=get&search=0x88FDE272AB3188D8)

You can import these keys via:

```shell
gpg --keyserver pgp.mit.edu --recv-keys 88FDE272AB3188D8
```

Since release 2.5.6-2, GPG signatures were included, and you will also find content of these signatures in build log at Travis-CI.

Since release 3.0.1-1, checksum files and GPG signatures are excluded from release file list, thus the **ONLY** checksum list you could find is the one in the travis build log.

**Just make sure that all the files are released by Travis-CI, but not by neithor me nor any third party.**
