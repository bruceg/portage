inherit eutils

DESCRIPTION="Bruce's Cron System"
HOMEPAGE="http://untroubled.org/bcron/"
SRC_URI="http://untroubled.org/bcron/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 sparc"
IUSE=""

DEPEND="!virtual/cron
	>=dev-libs/bglibs-0.18"
RDEPEND="!virtual/cron
	virtual/editor
	virtual/mta
	sys-apps/cronbase
	sys-apps/ucspi-unix
	>=supervise-scripts-3.5"
PROVIDE="virtual/cron"
S=${WORKDIR}/${P}

src_compile() {
	echo "${CC} ${CFLAGS}" >conf-cc
	echo "${CC} ${LDFLAGS}" >conf-ld
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
	rm -f insthier.o conf_bin.c
	make installer instcheck instshow
	dodir /usr/bin
	./installer
	./instshow

	insinto /etc
	doins ${FILESDIR}/crontab

	doman *.[12345678]

	newrun bcron-sched.run /var/service/bcron-sched
	newrun bcron-sched-log.run /var/service/bcron-sched/log
	newrun bcron-spool.run /var/service/bcron-spool
	newrun bcron-update.run /var/service/bcron-update

	dodir /var/log/bcron
	keepdir /var/log/bcron

	dodir /etc/bcron
	keepdir /etc/bcron
	
	dodir /var/spool/cron/{crontabs,tmp}
	keepdir /var/spool/cron/{crontabs,tmp}
	fowners cron:cron /var/spool/cron/{,crontabs,tmp}
	fperms go-rwx /var/spool/cron/{,crontabs,tmp}
}

pkg_postinst() {
	test -p /var/spool/cron/trigger || (
		mkfifo /var/spool/cron/trigger
		chown cron:cron /var/spool/cron/trigger
		chmod 600 /var/spool/cron/trigger
	)

	for svc in bcron-{sched,spool,update}; do
		if [ -e /service/$svc ]; then
			einfo "Restarting $svc"
			svc -t /service/$svc
		else
			einfo "Installing service $svc"
			svc-add $svc
		fi
	done
}

pkg_postrm() {
	test -x /usr/bin/bcron-sched || (
		for svc in bcron-{sched,spool,update}; do
			if [ -L /service/$svc ]; then
				svc-remove $svc
			fi
		done
	)
}
