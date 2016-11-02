# Prebuilt shadowsocks-libev for tomato-based router.

![Travis CI Building Status](https://travis-ci.org/xc2/shadowsocks-libev-tomato.svg?branch=master)

Thanks to [Travis CI](https://travis-ci.org) and Github, I managed to build and host [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) for [TomatoUSB](http://tomatousb.org/)-based ROM(eg., [Asuswrt Merlin](https://github.com/RMerl/asuswrt-merlin), [Tomato by shibby](http://tomato.groov.pl/)) continuously.

## What's done and what's not

- [x] Mipsel version with merlin toolchain (may also work with other mipsel version ROM)
- [ ] Mipsel version with shibby toolchain
- [ ] ARM version with merlin toolchain
- [ ] ARM version with shibby-AC toolchain
- [ ] Release checksum files simultaneously

As toolchains from merlin may be same with the ones from shibby, follow the arch first when choose which binary to download.

## Shut up and give me the link

You can get the prebuilt binaries from [Release](https://github.com/xc2/shadowsocks-libev-tomato/releases) page of this repository.
