#!/bin/sh
# make-dist.sh -- make source distribution

[ -z "$AUTOCONF" ] && AUTOCONF="autoconf"

[ -f Makefile ] && make distclean

$AUTOCONF
rm -rf autom4te.cache

pwd=${PWD:-`pwd`}
pkgname=rskkserv-`sed -ne 's/^VERSION=//p' configure.in`
cd ..

if [ "`basename $pwd`" == "rskkserv-cvs" -a ! -e $pkgname ]; then
    cp -pr rskkserv-cvs $pkgname
    find $pkgname \( -name CVS -type d \) -o -name .cvsignore |
	xargs rm -rf
fi
tar czf ${pkgname}.tar.gz $pkgname

cd $pwd
