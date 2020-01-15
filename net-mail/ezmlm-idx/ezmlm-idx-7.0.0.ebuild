# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx/ezmlm-idx-0.40-r2.ebuild,v 1.16 2005/04/24 10:19:58 hansmi Exp $

inherit eutils toolchain-funcs

IUSE="postgres mysql"

DESCRIPTION="Simple yet powerful mailing list manager for qmail."
SRC_URI="http://www.ezmlm.org/archive/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.ezmlm.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~alpha ~hppa ~amd64 ~ppc ~mips ~sparc"
DEPEND="sys-apps/grep sys-apps/groff
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/postgresql-base )"
RDEPEND="|| ( virtual/qmail mail-mta/qmail )"

src_unpack() {
	unpack ${A}
	cd ${S}
	echo "/usr/bin" > conf-bin
	echo "/usr/lib/ezmlm" > conf-lib
	echo "/usr/share/man" > conf-man
	echo $(tc-getCC) ${CFLAGS} -I/usr/include/mysql > conf-cc
	echo $(tc-getCC) ${CFLAGS} -s > conf-ld
}

src_compile() {
	cd ${S}
	emake it install || die
	use mysql && emake mysql || die
	use postgres && emake pgsql || die
}

src_install () {
	dodir /usr/bin
	./install ${D}/usr/bin <BIN || die

	dodir /usr/lib/ezmlm
	./install ${D}/usr/lib/ezmlm <LIB || die

	dodir /usr/share/man
	# Skip installing the cat-man pages
	grep -v :/cat MAN | ./install ${D}/usr/share/man || die

	dodir /etc/ezmlm
	./install ${D}/etc/ezmlm <ETC || die

	# Bug #47668 -- need to install ezmlm-cgi
	dobin ezmlm-cgi

}
