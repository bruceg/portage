# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/modplugxmms/modplugxmms-2.04.ebuild,v 1.7 2004/09/01 17:37:05 eradicator Exp $

inherit eutils

IUSE=""

DESCRIPTION="XMMS plugin for MOD-like music files"
SRC_URI="mirror://sourceforge/modplug-xmms/${P}.tar.gz"
HOMEPAGE="http://modplug-xmms.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
#-sparc: 2.04: Bus error when starting playback crashed xmms
KEYWORDS="x86 amd64 -sparc"

DEPEND=">=media-sound/xmms-1.2.5-r1
	>=media-sound/libmodplug-0.7"

src_compile() {
	econf || die "could not configure"
	emake LDFLAGS="$LDFLAGS -L${D}/usr/lib/" || die "emake failed"
}

src_install () {
	einstall \
		plugindir=${D}/usr/lib/xmms/Input || die
	dodoc AUTHORS COPYING ChangeLog INSTALL README TODO
}

pkg_postinst() {
	einfo "Open XMMS, go to options->preferences->I/O plugins."
	einfo "If \"MikMod Player\" is listed under \"Input Plugins\", click on"
	einfo "it and UNcheck \"Enable Plugin\"."
	einfo "(If you don't disable MikMod, it will play mods instead of ModPlug.)"
}
