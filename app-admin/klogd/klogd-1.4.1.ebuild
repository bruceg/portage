# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sysklogd/sysklogd-1.4.1-r11.ebuild,v 1.5 2005/06/26 07:19:40 vapier Exp $

inherit eutils

DESCRIPTION="Standard log daemons"
HOMEPAGE="http://www.infodrom.org/projects/sysklogd/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/daemons/sys${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""
RESTRICT="test"
S="${WORKDIR}/sys${P}"

DEPEND=""
RDEPEND="sys-process/supervise-scripts"
PROVIDE="virtual/logger"

src_unpack() {
	unpack "${A}"

	cd "${S}"
	epatch "${FILESDIR}/klogd-nofork.patch" || die
	epatch "${FILESDIR}"/sys${P}-2.6.headers.patch
	epatch "${FILESDIR}"/sys${PN}-1.4.1-mips.patch

	sed -i \
		-e "s:-O3:${CFLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE:" \
		Makefile || die "sed CFLAGS"
}

src_compile() {
	emake klogd LDFLAGS="" || die
}

src_install() {
	enewuser kernelog

	dosbin klogd
	dobin "${FILESDIR}/klogd-reload"
	doman klogd.8
	dodoc ANNOUNCE CHANGES MANIFEST NEWS README.1st README.linux

	dodir /var/service/klogd/log
	exeinto /var/service/klogd
	newexe "${FILESDIR}/klogd.run" run
	exeinto /var/service/klogd/log
	newexe "${FILESDIR}/klogd-log.run" run

	diropts -o kernelog -g kernelog
	dodir /var/log/kernel
	keepdir /var/log/kernel
}

pkg_preinst() {
	enewgroup kernelog || die "Problem adding kernelog group"
	enewuser kernelog -1 /bin/false /dev/null kernelog || die "Problem adding kernelog user"
}

pkg_postinst() {
	if [ -e /service/klogd ]; then
		einfo "Restarting klogd"
		svc -t /service/klogd
	else
		einfo "Installing service klogd"
		svc-add klogd
	fi
}

pkg_postrm() {
	if ! [ -x /usr/bin/klogd ]; then
		if [ -L /service/klogd ]; then
			svc-remove klogd
		fi
	fi
}
