# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit autotools ruby-fakegem

DESCRIPTION="An interactive shell for git"
HOMEPAGE="https://github.com/thoughtbot/gitsh"
SRC_URI="https://github.com/thoughtbot/gitsh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 amd64 ~amd64-linux"
IUSE=""

RDEPEND+=" sys-libs/readline "

ruby_add_rdepend "
	dev-ruby/bundler
	dev-ruby/parslet
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

each_ruby_install() {
	default
}
