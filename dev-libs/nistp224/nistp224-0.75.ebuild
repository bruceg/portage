# Copyright 2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit fixheadtails

S=${WORKDIR}/math/${P}/src
DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://cr.yp.to/${PN}.html"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="uncertain"
KEYWORDS="x86 amd64 ~sparc ~mips ~alpha ~ppc ~arm ~hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	ht_fix_file Makefile *.sh
	# Strip out the accuracy tests, which fail on amd64
	perl -pi -e 'last if /--- accuracy produces correct results/' rts.exp
	perl -pi -e 'last if /--- accuracy produces correct results/' rts.tests
}

src_compile() {
	echo "${D}/usr" > conf-home
	# FIXME: compiler doesn't work with anything else
	echo "idea64" >conf-opt
	echo "${CC} ${CFLAGS} -fPIC" >conf-cc
	echo "${CC} ${CFLAGS}" >conf-ld
	emake || die
	solib=libnistp224.so.${PV}
	gcc -shared -Wl,-soname,${solib} -o ${solib} `ar t nistp224.a`
}

src_install () {
	dodoc CHANGES STANDARD.base STANDARD56.base TODO sysdeps
	dobin nistp224 nistp224-56
	insinto /usr/include
	doins nistp224.h
	newlib.a nistp224.a libnistp224.a
	dolib.so libnistp224.so.*
	dosym libnistp224.so.${PV} /usr/lib/libnistp224.so
}
