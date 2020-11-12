# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs

DESCRIPTION="CVM modules for unix and pwfile, plus testclient"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="http://untroubled.org/cvm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc ~ppc"
IUSE="mysql postgres sqlite vpopmail"
PATCHES=(
	"$FILESDIR/cvm-0.97-sasl-failure-username.patch"
)

RDEPEND="virtual/libc
	>=dev-libs/bglibs-2.04:0/2"
DEPEND="${RDEPEND}
	sys-devel/libtool
	mysql? ( dev-db/mysql-connector-c )
	postgres? ( dev-db/postgresql )
	vpopmail? ( net-mail/vpopmail )
	sqlite? ( =dev-db/sqlite-3* )"

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user

	echo "/usr/$(get_libdir)" > conf-lib
	echo "/usr/include" >conf-include
	echo "/usr/bin" >conf-bin
	echo "$(tc-getCC) ${CFLAGS} -I/var/vpopmail/include" > conf-cc
	echo "$(tc-getCC) -L/usr/$(get_libdir)/bglibs -L/var/vpopmail/lib" > conf-ld
	sed -i 's/echo -n >/echo >/' Makefile
}

src_compile() {
	emake -j1 || die
	if use mysql; then
		emake mysql || die
	fi
	if use postgres; then
		emake pgsql || die
	fi
	if use vpopmail; then
		emake cvm-vchkpw || die
	fi
	if use sqlite; then
		emake sqlite || die
	fi
}

src_install() {
	make install install_prefix="$D" || die "install failed"

	dodoc ANNOUNCEMENT FILES NEWS README TARGETS TODO VERSION
	dohtml *.html
}
