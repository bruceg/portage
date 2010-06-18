inherit eutils

CVS_DATE=${PV#*_pre}
MY_P=sysklogd-1.4.1

DESCRIPTION="Kernel log daemon"
HOMEPAGE="http://www.infodrom.org/projects/sysklogd/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/daemons/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-cvs-${CVS_DATE}.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE=""
RESTRICT="test"
S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND="sys-process/supervise-scripts"
PROVIDE="virtual/logger"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${WORKDIR}"/${MY_P}-cvs-${CVS_DATE}.patch
	epatch "${FILESDIR}/klogd-nofork.patch"
	epatch "${FILESDIR}"/sysklogd-${PV}-2.6.headers.patch

	sed -i \
		-e "s:-O3:${CFLAGS} -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE:" \
		Makefile || die "sed CFLAGS"
}

pkg_setup() {
	enewgroup kernelog || die "Problem adding kernelog group"
	enewuser kernelog -1 -1 /dev/null kernelog || die "Problem adding kernelog user"
}

src_compile() {
	emake klogd LDFLAGS="" || die
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
