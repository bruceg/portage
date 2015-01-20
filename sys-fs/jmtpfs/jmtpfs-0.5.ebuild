# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools

DESCRIPTION="A FUSE and libmtp based filesystem for accessing MTP devices"
HOMEPAGE="https://github.com/JasonFerrara/jmtpfs"
SRC_URI="https://github.com/JasonFerrara/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libmtp-1.1.6
	sys-fs/fuse"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=(AUTHORS NEWS README)

src_prepare() {
	eautoreconf
}
