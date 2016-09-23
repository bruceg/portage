# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A loudness scanner implementing ITU-R BS.1770"
HOMEPAGE="http://bs1770gain.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-sound/sox
	virtual/ffmpeg
	"
RDEPEND="${DEPEND}"

DOCS=( bs1770gain/doc AUTHORS ChangeLog NEWS README )
