# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="Backup ARCHiver"
HOMEPAGE="http://untroubled.org/barch/"
SRC_URI="http://untroubled.org/barch/barch-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/bglibs-1.024"
RDEPEND="virtual/libc"

src_compile() {
	echo /usr/include/bglibs >conf-bgincs
	echo /usr/lib/bglibs >conf-lib
	tc-getCC >conf-cc
	tc-getCC >conf-ld
	emake || die
}

src_install() {
	echo /usr/bin >conf-bin
	echo /usr/share/man >conf-man
	emake install_prefix=${D} install || die "install failed"
	dodoc ANNOUNCEMENT COPYING NEWS README ChangeLog TODO VERSION
	dodoc *.html
}
