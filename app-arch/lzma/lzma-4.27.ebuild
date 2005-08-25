# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="LZMA Stream Compressor from the SDK"
HOMEPAGE="http://www.7-zip.org/sdk.html"
SRC_URI="mirror://sourceforge/sevenzip/${PN}427.tar.bz2"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_compile() {
	cd SRC/7zip/Compress/LZMA_Alone
	emake -f makefile.gcc \
		CXX="$(tc-getCXX) ${CXXFLAGS}" \
		CXX_C="$(tc-getCC) ${CFLAGS}" \
	|| die "Make failed"
}

src_install() {
	dobin SRC/7zip/Compress/LZMA_Alone/lzma
	dodoc *.txt
	dohtml *.html
}
