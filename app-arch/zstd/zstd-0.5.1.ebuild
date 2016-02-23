# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Zstandard, a fast lossless compression algorithm"
HOMEPAGE="http://www.zstd.net/"
SRC_URI="https://github.com/Cyan4973/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	make CC="$(tc-getCC)" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" || die
}

src_install() {
	# The install target recompiles the libs, so it needs the CC settings too
	make install PREFIX=/usr DESTDIR="$D" CC="$(tc-getCC)" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" || die
	dodoc NEWS README.md
}
