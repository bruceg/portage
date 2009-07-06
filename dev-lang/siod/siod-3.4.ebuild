# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Scheme In One Defun - a small-footprint implementation of the Scheme programming language"
HOMEPAGE="http://people.delphiforums.com/gjc/siod.html"
SRC_URI="http://people.delphiforums.com/gjc/siod.tgz"

LICENSE="unknown"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND=""
S=${WORKDIR}/${P}

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unpack ${A}
	epatch ${FILESDIR}/rename-lchmod.patch
	# SIOD has /usr/local hard coded in pretty near every file
	perl -pi -e 's|/usr/local/|/usr/|g' `grep -l /usr/local/ *`
}

src_compile() {
	make linux || die
}

src_install() {
	make install IROOT="${D}" || die
	dodoc *.txt
	dohtml *.html
}
