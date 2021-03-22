# Copyright 2005-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils multilib qmail toolchain-funcs

IUSE="postgres mysql sqlite"

DESCRIPTION="Simple yet powerful mailing list manager for qmail."
SRC_URI="http://www.ezmlm.org/archive/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.ezmlm.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
DEPEND="sys-apps/grep sys-apps/groff
	mysql? ( dev-db/mysql-connector-c )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="virtual/qmail"

src_unpack() {
	unpack ${A}
	cd "${S}" || die

	echo /usr/bin > conf-bin
	echo /usr/$(get_libdir)/ezmlm > conf-lib
	echo /etc/ezmlm > conf-etc
	echo /usr/share/man > conf-man
	echo ${QMAIL_HOME} > conf-qmail

	echo $(tc-getCC) ${CFLAGS} -I/usr/include/{my,postgre}sql > conf-cc
	echo $(tc-getCC) ${CFLAGS} -Wl,-E > conf-ld
}

src_compile() {
	emake it man installer || die
	if use mysql; then emake mysql || die; fi
	if use postgres; then emake pgsql || die; fi
	if use sqlite; then emake sqlite3 || die; fi
}

src_install () {
	dodir /usr/bin
	./installer "$D"/usr/bin <BIN || die

	dodir /usr/$(get_libdir)/ezmlm
	./installer "$D"/usr/$(get_libdir)/ezmlm <LIB || die

	dodir /usr/share/man
	# Skip installing the cat-man pages
	grep -v :/cat MAN | ./installer "$D"/usr/share/man || die

	dodir /etc/ezmlm
	./installer "$D"/etc/ezmlm <ETC || die

	# Bug #47668 -- need to install ezmlm-cgi
	dobin ezmlm-cgi

	dobin ezmlm-import ezmlm-rmtab
}
