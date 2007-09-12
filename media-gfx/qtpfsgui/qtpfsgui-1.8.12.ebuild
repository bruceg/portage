# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Qtpfsgui is a graphical user interface that provides a workflow for HDR imaging."
HOMEPAGE="http://qtpfsgui.sourceforge.net"
SRC_URI="mirror://sourceforge/qtpfsgui/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""
RESTRICT="nostrip"
DEPEND=">=x11-libs/qt-4.2.3-r1
	>=media-gfx/exiv2-0.14
	>=sci-libs/fftw-3.0.1-r2
	>=media-libs/jpeg-6b-r7
	>=media-libs/tiff-3.8.2-r2
	>=media-libs/openexr-1.2.2-r2"

src_compile() {
	einfo "Building langpacks..."
	/usr/bin/lrelease project.pro || die "lrelease failed"

	/usr/bin/qmake I18NDIR=/usr/share/${PN}/i18n PREFIX=/usr || die "qmake failed"
	emake || die "emake failed"

}

src_install() {
	dobin qtpfsgui
	dodoc AUTHORS Changelog README TODO
	insinto "/usr/share/${PN}/html"
	doins html/*
	insinto "/usr/share/${PN}/html/images"
	doins html/images/*
	insinto /usr/share/pixmaps
	doins "images/${PN}.png"
	insinto "/usr/share/${PN}/i18n"                         
	doins i18n/*.qm  
	make_desktop_entry qtpfsgui "Qtpfsgui" "/usr/share/pixmaps/${PN}.png" "Graphics"
}
