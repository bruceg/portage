inherit toolchain-funcs

DESCRIPTION="Mail server network protocol front-ends"
HOMEPAGE="http://untroubled.org/mailfront/"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc ~ppc"
IUSE="lua"

RDEPEND="virtual/libc
	>=dev-libs/bglibs-2.03
	>=net-libs/cvm-0.97
	lua? ( dev-lang/lua )"
DEPEND="${RDEPEND}"

src_compile() {
	echo "/usr/bin" > conf-bin
	echo "/var/qmail" > conf-qmail
	echo "/usr/include" >conf-include
	echo "/usr/lib/mailfront" >conf-modules
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC)" > conf-ld
	echo "$(tc-getCC) -fPIC -shared" >conf-ccso
	make || die
	if use lua
	then
		make lua || die
	fi
}

src_install() {
	dodir /var/qmail/bin
	make install_prefix=${D} install || die

	exeinto /var/qmail/supervise/qmail-smtpd
	newexe ${FILESDIR}/run-smtpfront run.mailfront
	exeinto /var/qmail/supervise/qmail-pop3d
	newexe ${FILESDIR}/run-pop3front run.mailfront

	dodoc ANNOUNCEMENT COPYING ChangeLog NEWS README VERSION
	dohtml *.html
}

pkg_config() {
	cd /var/qmail/supervise/qmail-smtpd/
	cp run run.qmail-smtpd.`date +%Y%m%d%H%M%S` && cp run.mailfront run
	cd /var/qmail/supervise/qmail-pop3d/
	cp run run.qmail-pop3d.`date +%Y%m%d%H%M%S` && cp run.mailfront run
}

pkg_postinst() {
	echo
	einfo "Run "
	einfo "ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config"
	einfo "to update your run files (backups are created) in"
	einfo "		/var/qmail/supervise/qmail-pop3d and"
	einfo "		/var/qmail/supervise/qmail-smtpd"
	echo
}
