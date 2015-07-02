EAPI=5

inherit eutils toolchain-funcs user

DESCRIPTION="Syslog message handling toolkit"
HOMEPAGE="http://untroubled.org/syslogread/"
SRC_URI="http://untroubled.org/syslogread/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 sparc"
IUSE=""

DEPEND=">=dev-libs/bglibs-0.19:0"
RDEPEND="${DEPEND}
	>=sys-process/supervise-scripts-3.5"
PROVIDE="virtual/logger"

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" >conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" >conf-ld
	echo /usr/lib/bglibs/include >conf-bgincs
	echo /usr/lib/bglibs/lib >conf-bglibs
	emake programs || die "compile problem"
}

newrun() {
	dodir "$2"
	exeinto "$2"
	newexe "$1" run
}

src_install() {
	echo ${D}/usr/bin >conf-bin
	echo ${D}/usr/share/man >conf-man
	dodir /usr/bin
	make install

	newrun sysloglread.run /var/service/sysloglread
	newrun sysloglread-log.run /var/service/sysloglread/log

	diropts -o syslogrd -g syslogrd
	dodir /var/log/syslog
	keepdir /var/log/syslog
}

pkg_preinst() {
	enewgroup syslogrd || die "Problem adding syslogrd group"
	enewuser syslogrd -1 /bin/false /dev/null syslogrd || die "Problem adding syslogrd user"
}

pkg_postinst() {
	if [ -e /service/sysloglread ]; then
		einfo "Restarting sysloglread"
		svc -t /service/sysloglread
	else
		einfo "Installing service sysloglread"
		svc-add sysloglread
	fi
}

pkg_postrm() {
	if ! [ -x /usr/bin/sysloglread ]; then
		if [ -L /service/sysloglread ]; then
			svc-remove sysloglread
		fi
	fi
}
