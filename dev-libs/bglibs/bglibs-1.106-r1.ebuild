# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit fixheadtails eutils toolchain-funcs

DESCRIPTION="Bruce Guenters Libraries Collection"
HOMEPAGE="http://untroubled.org/bglibs/"
SRC_URI="http://untroubled.org/bglibs/archive/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ~mips ~alpha ~ppc ~arm amd64 ~hppa"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	sys-devel/libtool"

src_compile() {
	echo /usr/bin >conf-bin
	echo /usr/include/bglibs > conf-include
	echo /usr/lib/bglibs > conf-lib
	echo /usr/share/man >conf-man
	echo "$(tc-getCC) ${CFLAGS} -g" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS} -s" > conf-ld
	emake || die
}

src_test() {
	einfo "Running selftests"
	emake selftests
}

src_install () {
	emake install_prefix="$D" install || die "install failed"

	#make backwards compatible symlinks
	dosym . /usr/lib/bglibs/lib

	# Remove bits that conflict with bglibs:2
	rm -rf "$D"/usr/include "$D"/usr/bin "$D"/usr/share/man/man1

	dodoc ANNOUNCEMENT NEWS README ChangeLog TODO VERSION
	docinto html
	dodoc doc/html/*
	docinto latex
	dodoc doc/latex/*

	dodir /etc/env.d
	echo LDPATH=/usr/lib/bglibs >""$D"/etc/env.d/99bglibs"
}

pkg_postinst() {
	# Upgrading causes these symlinks to get nuked
	if ! [ -e /usr/lib/bglibs/lib ]; then
		ln -s . /usr/lib/bglibs/lib
	fi
}
