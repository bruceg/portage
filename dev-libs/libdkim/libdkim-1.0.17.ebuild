# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="This project is a C++ library which allows incorporating DKIM into
an existing MTA or other application. It provides full support for signing,
verifying, and SSP. It is compliant with RFC 4871."
HOMEPAGE="http://sourceforge.net/projects/libdkim/"
SRC_URI="mirror://sourceforge/libdkim/libdkim-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}/src"

src_compile() {
	emake libdkim.a CFLAGS="${CFLAGS}" || die "Build failed"
}

src_install() {
	dolib.a libdkim.a

	insopts -m644
	insinto /usr/include
	doins dkim*.h
}
