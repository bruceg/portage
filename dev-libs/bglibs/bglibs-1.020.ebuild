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
	echo "${D}/usr/lib/bglibs" > conf-home
	echo "`tc-getCC` ${CFLAGS}" > conf-cc
	echo "`tc-getCC` ${LDFLAGS}" > conf-ld
	# parallel builds fail badly
	MAKEOPTS="`echo ${MAKEOPTS} | sed -re 's/-j[[:digit:]]+//g'`" \
	emake || die
}

src_install () {
	dodir /usr/lib/bglibs
	./installer || die "install failed"
	dodoc ANNOUNCEMENT COPYING NEWS README ChangeLog TODO VERSION
	docinto html
	dodoc doc/html/*
	docinto latex
	dodoc doc/latex/*
}
