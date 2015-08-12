# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cvm/cvm-0.18.ebuild,v 1.5 2004/10/17 11:23:00 dholm Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="CVM modules for unix and pwfile, plus testclient"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="http://untroubled.org/cvm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc ~ppc"
IUSE="mysql postgres sqlite3 vpopmail"

RDEPEND="virtual/libc
	>=dev-libs/bglibs-2.01:2"
DEPEND="${RDEPEND}
	sys-devel/libtool
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	vpopmail? ( net-mail/vpopmail )
	sqlite3? ( =dev-db/sqlite-3* )"

src_compile() {
	echo "/usr/lib" >conf-lib
	echo "/usr/include" >conf-include
	echo "/usr/bin" >conf-bin
	echo "$(tc-getCC) ${CFLAGS} -I/var/vpopmail/include" > conf-cc
	echo "$(tc-getCC) -L/var/vpopmail/lib" > conf-ld
	emake -j1 || die
	if use mysql; then
		emake -j1 mysql || die
	fi
	if use postgresql; then
		emake -j1 pgsql || die
	fi
	if use vpopmail; then
		emake -j1 cvm-vchkpw || die
	fi
	if use sqlite3; then
		emake -j1 sqlite || die
	fi
}

src_install() {
	make install install_prefix=${D} || die "install failed"

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
	dohtml *.html
}
