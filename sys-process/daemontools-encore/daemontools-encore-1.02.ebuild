# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils toolchain-funcs

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://untroubled.org/daemontools-encore/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!sys-process/daemontools"

src_compile() {
	echo $(tc-getCC) ${CFLAGS} >conf-cc
	echo $(tc-getCC) ${LDFLAGS} >conf-ld
	make
}

src_install() {
	echo ${D}/usr/bin >conf-bin
	echo ${D}/usr/share/man >conf-man
	dodir /usr/bin
	dodir /usr/share/man
	make install
}
