# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils versionator scons-utils python-single-r1 multilib

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Python binding to exiv2"
HOMEPAGE="http://tilloy.net/dev/pyexiv2/"
SRC_URI="http://launchpad.net/${PN}/${MY_PV}.x/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=">=media-gfx/exiv2-0.20
	dev-python/sphinx
	>=dev-libs/boost-1.49.0-r2[python]"
RDEPEND="${DEPEND}"

src_compile() {
	escons lib BOOSTLIB=boost_python-2.7 || die
	if use doc; then
		escons doc || die

		# To enable doins -r in src_install
		rm -R doc/_build/.doctrees || die
	fi
}

src_install() {
	escons DESTDIR="${D}" BOOSTLIB=boost_python-2.7 install || die
	dodoc NEWS README todo || die

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/*example*.py
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}/
		doins -r doc/html || die  # no dohtml due to mixed content
	fi

	python_optimize
}
