# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitsh/gitsh-0.8.ebuild,v 1.1 2014/11/05 11:44:28 jlec Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit autotools ruby-fakegem

DESCRIPTION="An interactive shell for git"
HOMEPAGE="https://github.com/thoughtbot/gitsh"
SRC_URI="https://github.com/thoughtbot/gitsh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 amd64 ~amd64-linux"
IUSE=""

ruby_add_rdepend "
	dev-vcs/gitsh
	"

DOCS="README.md"

each_ruby_prepare() {
	rm -f Gemfile.lock
	eautoreconf
}

each_ruby_configure() {
	default
}

each_ruby_compile() {
	default
}
