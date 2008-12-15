# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/openntpd/openntpd-3.9_p1-r1.ebuild,v 1.8 2007/10/04 04:39:07 jer Exp $

inherit eutils

MY_P=${P/_/}
DESCRIPTION="Lightweight NTP server ported from OpenBSD"
HOMEPAGE="http://www.openntpd.org/"
SRC_URI="mirror://openbsd/OpenNTPD/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ssl selinux"

RDEPEND="ssl? ( dev-libs/openssl )
	selinux? ( sec-policy/selinux-ntp )
	!<=net-misc/ntp-4.2.0-r2"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ntp 123
	enewuser ntp 123 -1 /var/empty ntp

	if has_version net-misc/ntp && ! built_with_use net-misc/ntp openntpd ; then
		die "you need to emerge ntp with USE=openntpd"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i '/NTPD_USER/s:_ntp:ntp:' ntpd.h || die
	epatch ${FILESDIR}/${MY_P}-linux-adjtimex.patch || die
	epatch ${FILESDIR}/openntpd-3.9p1_reconnect_on_sendto_EINVAL.diff
}

src_compile() {
	econf \
		--disable-strip \
		$(use_with !ssl builtin-arc4random) || die
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc ChangeLog CREDITS README

	newconfd "${FILESDIR}"/openntpd.conf.d ntpd

	dodir /var/service/ntpd/log
	insinto /var/service/ntpd
	newins ${FILESDIR}/ntpd.run run
	insinto /var/service/ntpd/log
	newins ${FILESDIR}/ntpd-log.run run
	fperms 1755 /var/service/ntpd
	fperms 700 /var/service/ntpd/run /var/service/ntpd/log/run
}
