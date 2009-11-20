inherit eutils toolchain-funcs

DESCRIPTION="Simple secure efficient FTP server"
HOMEPAGE="http://untroubled.org/twoftpd/"
SRC_URI="http://untroubled.org/twoftpd/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 sparc"
IUSE=""

DEPEND="
	>=dev-libs/bglibs-0.27
	>=net-libs/cvm-0.76
	"
RDEPEND="
	sys-apps/ucspi-tcp
	>=sys-process/supervise-scripts-3.5
	"

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" >conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" >conf-ld
	echo /usr/include/bglibs >conf-bgincs
	echo /usr/lib/bglibs >conf-bglibs
	emake programs || die "compile problem"
}

newrun() {
	dodir "$2"
	exeinto "$2"
	newexe "$1" run
}

src_install() {
	dobin twoftpd-{anon,anon-conf,auth,bind-port,conf,drop,switch,xfer}

	doman *.[12345678]

	dodoc ANNOUNCEMENT COPYING ChangeLog NEWS README TODO VERSION

	newrun twoftpd.run /var/service/twoftpd
	newrun twoftpd-log.run /var/service/twoftpd/log

	dodir /var/log/twoftpd
	keepdir /var/log/twoftpd

	dodir /etc/twoftpd
	keepdir /etc/twoftpd
}

pkg_postinst() {
	if [ -e /service/twoftpd ]; then
		einfo "Restarting twoftpd service"
		svc -t /service/twoftpd
	else
		einfo "Installing twoftpd service"
		svc-add twoftpd
	fi
}

pkg_postrm() {
	test -e /usr/bin/twoftpd-xfer || (
		if [ -L /service/twoftpd ]; then
			einfo "Removing twoftpd service"
			svc-remove twoftpd
		fi
	)
}
