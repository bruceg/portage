# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Double blind audio test tool"
HOMEPAGE="http://remco.beryllium.net/linabx/"
SRC_URI="http://remco.beryllium.net/linabx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=gnome-base/libgnome-2.10
	>=media-sound/jack-audio-connection-kit-0.100
	media-libs/libsamplerate
	media-libs/libsndfile"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	epatch ${FILESDIR}/no-scrollkeeper.patch || die
	econf || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS ChangeLog COPYING NEWS README TODO
}
