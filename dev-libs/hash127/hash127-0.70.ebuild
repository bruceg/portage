# Copyright 2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit fixheadtails

#S=${WORKDIR}/${P}
DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://cr.yp.to/${PN}.html"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="DJB"
KEYWORDS="x86 ~sparc ~mips ~alpha ~ppc ~arm ~amd64 ~hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	ht_fix_file Makefile
	sed -e 's/extern int errno;/#include <errno.h>/' error.h >error.h.new
	mv error.h.new error.h
}

src_compile() {
	echo "${D}/usr" > conf-home
	echo "${CC} ${CFLAGS} -fPIC" >conf-cc
	echo "${CC} ${CFLAGS}" >conf-ld
	emake || die
	./accuracy >accuracy.out
	cmp accuracy.exp accuracy.out
	./speed >speed.txt
	solib=libhash127.so.${PV}
	gcc -shared -Wl,-soname,${solib} -o ${solib} `ar t hash127.a`
}

src_install () {
	dodoc CHANGES README TODO VERSION speed.txt
	insinto /usr/include
	doins int32.h
	doins hash127.h
	insinto /usr/lib
	newins hash127.a libhash127.a
	dolib.so libhash127.so.${PV}
	dosym libhash127.so.${PV} /usr/lib/libhash127.so
}
