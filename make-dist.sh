#!/bin/sh
# make source distribution

[ -z "$AUTOCONF" ] && AUTOCONF="autoconf"

[ -f Makefile ] && make distclean

$AUTOCONF
rm -rf autom4te.cache

RD2HTML="${RD2:-rd2} ${RD2OPT} ${RD2HTMLOPT}"
HTML2TXT="${HTML2TXT:-w3m -I e -dump -T text/html}"

for rd in doc/INSTALL.rd doc/README.rd
do
    txt="`basename $rd .rd`"
    rm -f $txt
    $RD2HTML $rd | $HTML2TXT >$txt
done

PWD=${PWD:-`pwd`}
pkgname="`basename $PWD`"
cd ..
tar cf - $pkgname | gzip -9 >${pkgname}.tar.gz
cd $pkgname
