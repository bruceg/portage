# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs eutils

DESCRIPTION="Rate-limited autoresponder for qmail"
HOMEPAGE="http://untroubled.org/qmail-autoresponder/"
SRC_URI="http://untroubled.org/qmail-autoresponder/archive/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="mysql"
PATCHES=(
	"$FILESDIR/${PN}-2.0-remove-mysql.h.diff"
)

DEPEND="
	dev-libs/bglibs:2
	mysql? ( virtual/mysql )
"
RDEPEND="
	${DEPEND}
	virtual/qmail
"

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_compile() {
	emake
	use mysql && emake mysql
}

src_install () {
	dobin qmail-autoresponder || die
	doman qmail-autoresponder.1
	if use mysql
	then
		dobin qmail-autoresponder-mysql || die
		dodoc schema.mysql
	fi

	dodoc ANNOUNCEMENT NEWS README TODO ChangeLog procedure.txt
}

pkg_postinst() {
	elog "Please see the README file in /usr/share/doc/${PF}/ for per-user configurations."
}
