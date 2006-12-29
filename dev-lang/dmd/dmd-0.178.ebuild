# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Compiler for D Programming Language"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/dmd.${PV#0.}.zip"
S="${WORKDIR}/dmd"

LICENSE="Unknown"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin bin/dmd bin/dumpobj bin/obj2asm

	mkdir "${D}/etc"
	(
		echo '[Environment]'
		echo "DFLAGS=-I/usr/lib/phobos"
	)>"${D}/etc/dmd.conf"

	dolib lib/libphobos.a
	cp -a src/phobos "${D}/usr/lib/"

	dohtml html/d/*
}
