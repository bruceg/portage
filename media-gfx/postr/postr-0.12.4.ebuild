# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit distutils eutils

DESCRIPTION="GNOME Flickr Uploader"
HOMEPAGE="http://projects.gnome.org/postr/"
SRC_URI="http://ftp.acc.umu.se/pub/GNOME/sources/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/twisted dev-python/twisted-web"

