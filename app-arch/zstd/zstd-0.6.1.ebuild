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
	CC="$(tc-getCC)"
	emake -C lib libzstd CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
	# Prevent make install from rebuilding the libs
	touch lib/libzstd

	emake -C programs zstd CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
}

src_install() {
	emake install PREFIX=/usr DESTDIR="$D"
	dodoc NEWS README.md
}
