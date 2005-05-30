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
IUSE="mysql postgresql"

DEPEND="virtual/libc
	>=dev-libs/bglibs-1.018
	mysql? ( dev-db/mysql )
	postgresql? ( dev-db/postgresql )"
RDEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	echo "/usr/lib/bglibs/include" > conf-bgincs
	echo "/usr/lib/bglibs/lib" > conf-bglibs
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) -s" > conf-ld
	make || die
	[ `use mysql` ] && ( make mysql || die; )
	[ `use postgresql` ] && ( make pgsql || die; )
}

src_install() {
	dobin cvm-benchclient cvm-chain cvm-checkpassword \
		cvm-pwfile cvm-qmail cvm-testclient cvm-unix \
		cvm-vmailmgr cvm-vmailmgr-local cvm-vmailmgr-udp \
		cvm-v1benchclient cvm-v1checkpassword cvm-v1testclient \
	|| die "dobin failed"
	[ `use mysql` ] && (
		dobin cvm-mysql cvm-mysql-local cvm-mysql-udp || die "dobin failed"
	)
	[ `use postgresql` ] && (
		dobin cvm-pgsql cvm-pgsql-local cvm-pgsql-udp || die "dobin failed"
	)

	insinto /usr/include/cvm
	doins *.h
	dosym cvm/sasl.h /usr/include/cvm-sasl.h
	dosym v1client.h /usr/include/cvm/client.h

	newlib.a v1client.a libcvm-v1client.a
	newlib.a v2client.a libcvm-v2client.a
	newlib.a udp.a libcvm-udp.a
	newlib.a local.a libcvm-local.a
	newlib.a command.a libcvm-command.a
	newlib.a module.a libcvm-module.a
	newlib.a sasl.a libcvm-sasl.a
	dosym libcvm-v1client.a /usr/lib/libcvm-client.a

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
	dohtml *.html
}
