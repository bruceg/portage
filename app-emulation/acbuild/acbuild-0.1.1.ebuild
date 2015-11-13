# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Command line utility to build and modify App Container Images (ACIs)"
HOMEPAGE="https://github.com/appc/acbuild"
SRC_URI="https://github.com/appc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND=">=dev-lang/go-1.4.1"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s/^VERSION=.*$/VERSION=${PV}/" build
}

src_compile() {
	./build
}

src_install() {
	dobin bin/acbuild
	dodoc CHANGELOG.md README.md
	use examples && dodoc -r examples
}
