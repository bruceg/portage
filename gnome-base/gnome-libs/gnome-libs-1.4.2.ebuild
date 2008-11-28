# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/gnome-base/gnome-libs/gnome-libs-1.4.2.ebuild,v 1.7 2003/02/13 12:08:23 vapier Exp $

IUSE="nls kde"

inherit libtool eutils

DESCRIPTION="GNOME Core Libraries"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/1.4/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
KEYWORDS="x86 alpha amd64"
#  ppc sparc sparc64"

DEPEND=">=media-libs/imlib-1.9.10
		>=media-sound/esound-0.2.23
		>=gnome-base/orbit-0.5.12
		=x11-libs/gtk+-1.2*
		<sys-libs/db-2"

RDEPEND="nls? ( >=sys-devel/gettext-0.10.40 >=dev-util/intltool-0.11 )"

SLOT="1"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/compile-fixes.patch || die "patch failed"
}

src_compile() {                           
	CFLAGS="$CFLAGS -I/usr/include/db1"

	local myconf

	myconf="--disable-gtk-doc"
	use nls || myconf="${myconf} --disable-nls"
	use kde && myconf="${myconf} --with-kde-datadir=/usr/share"

	# libtoolize
	elibtoolize 

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--enable-prefer-db1 \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		docdir=${D}/usr/share/doc/${P} \
		HTML_DIR=${D}/usr/share/gnome/html \
		install || die

	rm ${D}/usr/share/gtkrc*

	dodoc AUTHORS COPYING* ChangeLog README NEWS HACKING
}

