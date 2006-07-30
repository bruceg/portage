# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cvm/cvm-0.18.ebuild,v 1.5 2004/10/17 11:23:00 dholm Exp $

inherit toolchain-funcs

DESCRIPTION="CVM modules for unix and pwfile, plus testclient"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="http://untroubled.org/cvm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc ~ppc"
IUSE="mysql postgresql vpopmail"

DEPEND="virtual/libc
	sys-devel/libtool
	>=dev-libs/bglibs-1.027
	mysql? ( dev-db/mysql )
	postgresql? ( dev-db/postgresql )
	vpopmail? ( net-mail/vpopmail )"
RDEPEND="virtual/libc"

src_compile() {
	echo "/usr/include/bglibs" > conf-bgincs
	echo "/usr/lib/bglibs" > conf-bglibs
	echo "/usr/lib" >conf-lib
	echo "/usr/include" >conf-include
	echo "$(tc-getCC) ${CFLAGS} -I/var/vpopmail/include" > conf-cc
	echo "$(tc-getCC) -L/var/vpopmail/lib" > conf-ld
	make || die
	if use mysql; then
		make mysql || die
	fi
	if use postgresql; then
		make pgsql || die
	fi
	if use vpopmail; then
		make cvm-vchkpw || die
	fi
}

src_install() {
	make install install_prefix=${D} || die "install failed"

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
	dohtml *.html
}
