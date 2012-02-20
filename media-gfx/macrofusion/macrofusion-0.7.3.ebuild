# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="GUI for Enfuse"
HOMEPAGE="https://sourceforge.net/projects/macrofusion/"
SRC_URI="mirror://sourceforge/macrofusion/macrofusion_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-lang/python-2.7
	dev-python/imaging
	dev-python/pygtk
	>=dev-python/pyexiv2-0.3
	>=gnome-base/libglade-2.0
	>=media-gfx/enblend-4.0"

src_install() {
	newbin macrofusion.py macrofusion

	insinto /usr/share/applications
	doins macrofusion.desktop

	insinto /usr/share/mfusion/ui
	doins ui/*

	insinto /usr/share/pixmaps
	doins images/macrofusion.png

	insinto /usr/share/mfusion/images
	doins images/logoSplash.png

	insinto /usr/share/locale
	cp -a locale/* ${D}/usr/share/locale/

	dodoc CHANGELOG README TODO
}
