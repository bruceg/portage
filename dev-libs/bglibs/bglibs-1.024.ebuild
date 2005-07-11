# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit fixheadtails eutils toolchain-funcs

S=${WORKDIR}/${P}
DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~mips ~alpha ~ppc ~arm amd64 ~hppa"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
}

src_compile() {
	echo /usr/lib/bglibs/include > conf-include
	echo /usr/lib/bglibs/lib > conf-lib
	echo /usr/bin >conf-bin
	echo "`tc-getCC` ${CFLAGS}" > conf-cc
	echo "`tc-getCC` ${LDFLAGS}" > conf-ld
	# parallel builds fail badly
	MAKEOPTS="`echo ${MAKEOPTS} | sed -re 's/-j[[:digit:]]+//g'`" \
	emake || die
}

src_test() {
	einfo "Running selftests"
	emake -j1 selftests
}

src_install () {
	emake install_prefix=${D} install || die "install failed"

	#move stuff
	dodir /usr/include
	mv ${D}/usr/lib/bglibs/include ${D}/usr/include/bglibs
	mv ${D}/usr/lib/bglibs/lib/* ${D}/usr/lib/bglibs
	rmdir ${D}/usr/lib/bglibs/lib

	#make backwards compatible symlinks
	dosym . /usr/lib/bglibs/lib
	dosym ../../include/bglibs /usr/lib/bglibs/include

	dodoc ANNOUNCEMENT COPYING NEWS README ChangeLog TODO VERSION
	docinto html
	dodoc doc/html/*
	docinto latex
	dodoc doc/latex/*
}

pkg_postinst() {
	# Upgrading causes these symlinks to get nuked
	if ! [ -e /usr/lib/bglibs/lib ]; then
		ln -s . /usr/lib/bglibs/lib
	fi
	if ! [ -e /usr/lib/bglibs/include ]; then
		ln -s ../../include/bglibs /usr/lib/bglibs/include
	fi
}
