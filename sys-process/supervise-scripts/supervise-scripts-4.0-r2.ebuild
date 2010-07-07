# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/supervise-scripts/supervise-scripts-3.5.ebuild,v 1.5 2006/10/22 12:36:02 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Starting and stopping daemontools managed services"
HOMEPAGE="http://untroubled.org/supervise-scripts/"
SRC_URI="http://untroubled.org/supervise-scripts/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="|| ( >=sys-process/daemontools-0.76 sys-process/daemontools-encore )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo '/usr/bin' > conf-bin
	echo '/usr/share/man' > conf-man
}

src_compile() {
	emake || die
}

src_install() {
	make PREFIX="$D" install
	dodoc ANNOUNCEMENT ChangeLog NEWS README TODO VERSION
}
