# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib libtool

DESCRIPTION="Library for correcting images based on lens characteristics and callibration data"
HOMEPAGE="http://lensfun.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )
	dev-lang/python"
RDEPEND=""

src_compile() {
	./configure --prefix=/usr --datadir=/usr/share/lensfun --sysconfdir=/etc \
	|| die "configure failed"
	emake libs tools tests data || die "emake failed"
	use doc && emake docs || die "emake docs failed"
}

src_install() {
	einstall INSTALL_PREFIX=${D} || die "einstall failed"
}

