# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="library to add DomainKeys functionality"
HOMEPAGE="http://domainkeys.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Yahoo! DomainKeys Public License"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	make dns.lib
	echo -lresolv >>dns.lib
	make
}

src_install() {
	dobin dktest
	dolib libdomainkeys.a
	insinto /usr/include
	doins domainkeys.h
}
