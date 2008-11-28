# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/gnome-base/orbitORBit-0.5.17.ebuild,v 1.12 2003/06/20 02:58:31 kumba Exp $

IUSE="nls"

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="A high-performance, lightweight CORBA ORB aiming for CORBA 2.2 compliance"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/0.5/${P}.tar.bz2"
HOMEPAGE="http://www.labs.redhat.com/orbit/"

DEPEND="nls? ( sys-devel/gettext )
	>=sys-apps/tcp-wrappers-7.6
	=dev-libs/glib-1.2*"

RDEPEND="=dev-libs/glib-1.2*"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha ~mips amd64"

src_compile() {
	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	# Libtoolize to fix "relink bug" in older libtool's distributed
	# with packages.
	elibtoolize

	./configure --host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die

	make || die # Doesn't work with -j 4 (hallski)
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		localstatedir=${D}/var/lib \
		install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
	dodoc docs/*.txt docs/IDEA1

	docinto idl
	cd libIDL
	dodoc AUTHORS BUGS COPYING NEWS README*

	docinto popt
	cd ../popt
	dodoc CHANGES COPYING README

	cd ${D}/usr/lib
	patch -p0 < ${FILESDIR}/libIDLConf.sh-gentoo.diff
}

