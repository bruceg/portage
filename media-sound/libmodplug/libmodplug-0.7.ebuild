# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/modplugxmms/modplugxmms-2.04.ebuild,v 1.7 2004/09/01 17:37:05 eradicator Exp $

inherit eutils

IUSE=""

DESCRIPTION="Library for playing MOD-like music files"
SRC_URI="mirror://sourceforge/modplug-xmms/${P}.tar.gz"
HOMEPAGE="http://modplug-xmms.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
#-sparc: 2.04: Bus error when starting playback crashed xmms
KEYWORDS="x86 amd64 -sparc"

DEPEND=""

src_unpack() {
	unpack ${A} ; cd ${S}
	#epatch ${FILESDIR}/${P}.patch

	cd ${S}/src/libmodplug
	epatch ${FILESDIR}/${P}-amd64.patch
}

src_compile() {
	econf || die "could not configure"
	emake LDFLAGS="$LDFLAGS -L${D}/usr/lib/" || die "emake failed"
}

src_install () {
	einstall
	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
}
