# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Secure log transmission system"
SRC_URI="http://untroubled.org/${PN}/archive/${P}.tar.gz"
CURVE25519=curve25519-20050915

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
HOMEPAGE="http://untroubled.org/srlog2/"
RDEPEND="virtual/libc
	>=dev-libs/libtomcrypt-1.03
	>=dev-libs/nistp224-0.75
	>=dev-libs/bglibs-2.03:2"
DEPEND="${RDEPEND}"

PROVIDE=""

src_prepare() {
	echo "$(tc-getCC) ${CFLAGS}" >conf-cc
	echo "$(tc-getCC) ${CFLAGS} -s" >conf-ld
	echo "/usr/bin" >conf-bin
	echo "/usr/share/man" >conf-man
	echo /etc/srlog2 >conf-etc

	[[ -x /sbin/paxctl ]] && \
		sed -i -e '/^&& .\/curve25519/i&& paxctl -m curve25519.impl.check \\' $CURVE25519/curve25519.impl.do
	sed -i -e 's/) >/) -fPIC >/g' $CURVE25519/Makefile
}

src_compile() {
	emake all || die

	[[ -x /sbin/paxctl ]] && \
		paxctl -m srlog2 srlog2d srlog2-keygen
}

src_install() {
	make install install_prefix="$D"

	dodir /etc/srlog2
	dodir /etc/srlog2/env
	keepdir /etc/srlog2/env
	dodir /etc/srlog2/servers
	keepdir /etc/srlog2/servers
}

pkg_postinst() {
	echo "Don't forget to run 'emerge --config =${CATEGORY}/${PF}' to set up keys."
}

pkg_config() {
	for key in curve25519 nistp224; do
		if ! [ -e "$ROOT"/etc/srlog2/$key ]; then
			srlog2-keygen -t $key /etc/srlog2
		fi
	done
}
