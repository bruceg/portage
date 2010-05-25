# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="CacheFiles backend management daemon"
HOMEPAGE="http://people.redhat.com/~dhowells/fscache/"
SRC_URI="http://people.redhat.com/~dhowells/fscache/cachefilesd-${PV}.tar.bz2"

LICENSE="GPL-v2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="$CFLAGS" all \
	|| die "make died."
}

src_install() {
	emake DESTDIR="$D" install \
	|| die "make install died."
	dodoc howto.txt README
}
