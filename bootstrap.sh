#!/bin/sh

[ -z "$autoconf" ] && autoconf="autoconf"

[ -f Makefile ] && make distclean

$autoconf

./configure "$@"

make
