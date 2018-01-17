EAPI=5

inherit eutils user

MY_P="sysklogd-${PV}"
S="$WORKDIR/$MY_P"

DESCRIPTION="Kernel log daemon"
HOMEPAGE="http://www.infodrom.org/projects/sysklogd/"
SRC_URI="http://www.infodrom.org/projects/sysklogd/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND="sys-process/supervise-scripts"

pkg_setup() {
	enewgroup kernelog || die "Problem adding kernelog group"
	enewuser kernelog -1 -1 /dev/null kernelog || die "Problem adding kernelog user"
}

src_compile() {
	emake klogd || die
}

src_install() {
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
	enewuser kernelog -1 -1 /dev/null kernelog || die "Problem adding kernelog user"
}

pkg_postinst() {
	if [ -e /service/klogd ]; then
		einfo "Restarting klogd"
		svc -t /service/klogd /service/klogd/log
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
