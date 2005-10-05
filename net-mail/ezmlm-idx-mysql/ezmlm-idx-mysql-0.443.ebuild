# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/ezmlm-idx-mysql/ezmlm-idx-mysql-0.40-r2.ebuild,v 1.9 2004/07/15 01:46:15 agriffis Exp $

# NOTE: ezmlm-idx, ezmlm-idx-mysql and ezmlm-idx-pgsql all supported by this single ebuild
# (Please keep them in sync)

inherit eutils fixheadtails

PB=ezmlm-idx
EZMLM_P=ezmlm-0.53

S2=${WORKDIR}/${PB}-${PV}
S=${WORKDIR}/${EZMLM_P}
DESCRIPTION="Simple yet powerful mailing list manager for qmail."
SRC_URI="http://www.ezmlm.org/archive/${PV}/${PB}-${PV}.tar.gz http://cr.yp.to/software/${EZMLM_P}.tar.gz"
HOMEPAGE="http://www.ezmlm.org"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 alpha ~hppa ~amd64 ~ppc ~mips ~sparc"
IUSE=""
DEPEND="sys-apps/grep sys-apps/groff"
RDEPEND="mail-mta/qmail"

if [ "$PN" = "${PB}-pgsql" ]
then
	DEPEND="$DEPEND dev-db/postgresql"
	RDEPEND="$RDEPEND dev-db/postgresql"
elif [ "$PN" = "${PB}-mysql" ]
then
	DEPEND="$DEPEND dev-db/mysql"
	RDEPEND="$RDEPEND dev-db/mysql"
fi

src_unpack() {
	unpack ${A}
	cd ${S2}
	mv ${S2}/* ${S} || die

	cd ${S}
	patch < idx.patch || die
	echo "/usr/bin" > conf-bin
	echo "/usr/share/man" > conf-man
	echo "gcc ${CFLAGS}" > conf-cc
	echo "gcc" > conf-ld
	#apply patch from Ed Korthof (edk@collab.net) that allows ezmlm-issub  and ezmlm-gate
	#to check against the From: header as well as qmail's SENDER variable, which is set
	#from the envelope sender and often reflects the local MTA rather than the user's
	#"official" email address... enable this option by using "-f" with ezmlm-issub and/or
	#ezmlm-gate.
	#cp ${FILESDIR}/get_header.[ch] . || die
	#patch < ${FILESDIR}/from-header.patch || die
	#echo ">>> Successfully applied Ed Korthof's From: header patch."
}

src_compile() {
	cd ${S}
	if [ "$PN" = "${PB}-pgsql" ]
	then
		echo pgsql >conf-sub
	elif [ "$PN" = "${PB}-mysql" ]
	then
		echo mysql >conf-sub
	fi
	emake it install || die
}

src_install () {
	dodir /usr/bin
	dodir /usr/share/man
	dodir /etc/ezmlm
	./install ${D}/usr/bin <BIN
	# Skip installing the cat-man pages
	grep -v :/cat MAN | ./install ${D}/usr/share/man
	mv ${D}/usr/bin/ez*rc ${D}/etc/ezmlm
	# Bug #47668 -- need to install ezmlm-cgi
	dobin ezmlm-cgi
}
