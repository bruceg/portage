# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="C library for the Flickr API"
HOMEPAGE="http://librdf.org/flickcurl/"
SRC_URI="http://download.dajobe.org/flickcurl/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="raptor"

DEPEND=">=net-misc/curl-7.10.0
	>=dev-libs/libxml2-2.6.8
	raptor? ( >=media-libs/raptor-1.4.0 )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with raptor)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS NEWS.html NOTICE README README.html
}
