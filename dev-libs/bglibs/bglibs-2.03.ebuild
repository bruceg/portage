# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit fixheadtails eutils toolchain-funcs

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/archive/${P}.tar.gz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~mips ~alpha ~ppc ~arm amd64 ~hppa"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	!<=dev-libs/bglibs-1.106
	sys-devel/libtool"

src_compile() {
	echo /usr/bin >conf-bin
	echo /usr/include > conf-include
	echo /usr/$(get_libdir) > conf-lib
	echo /usr/share/man >conf-man
	echo "$(tc-getCC) ${CFLAGS} -g" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS} -s" > conf-ld
	emake libraries programs || die
}

src_test() {
	einfo "Running selftests"
	emake selftests
}

src_install () {
	emake install_prefix=${D} install || die "install failed"

	dodoc ANNOUNCEMENT COPYING NEWS README ChangeLog TODO VERSION
	docinto html
	dodoc doc/html/*
	docinto latex
	dodoc doc/latex/*
}
