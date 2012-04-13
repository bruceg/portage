# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WX_GTK_VER="2.8"

inherit eutils wxwidgets

DESCRIPTION="open-source, cross platform IDE for the C/C++ programming languages"
HOMEPAGE="http://www.codelite.org/"
SRC_URI="mirror://sourceforge/codelite/Releases/codelite-${PV%.*.*}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~arm ~alpha ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="debug mysql postgres subversion"

DEPEND=">=x11-libs/wxGTK-2.8[X]
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	subversion? ( dev-vcs/subversion )
	net-misc/curl
	>=sys-devel/gdb-7.1"

RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable mysql) \
		$(use_enable postgres) || die "configure failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS COPYING LICENSE

	# reverting the makefiles 666 chmod for this file
	chmod 0644 "${D}"/usr/share/codelite/codelite-icons.zip
}

