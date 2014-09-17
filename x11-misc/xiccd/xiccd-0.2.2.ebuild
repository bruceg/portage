# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools

DESCRIPTION="A simple bridge between colord and X"
HOMEPAGE="https://github.com/agalakhov/xiccd"
SRC_URI="https://github.com/agalakhov/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="x11-apps/xrandr
	x11-misc/colord
	dev-libs/glib
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_install() {
	dobin src/xiccd
	dodoc AUTHORS ChangeLog NEWS README
}
