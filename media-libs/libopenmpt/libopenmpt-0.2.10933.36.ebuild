# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

beta="${PV#*.*.*.}"
MV="${PV%.$beta}"
SV="${MV}-beta$beta"

DESCRIPTION="library to decode tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/libopenmpt/src/${PN}-${SV}-autotools.tar.gz"
S="$WORKDIR/${PN}-0.2.10934-autotools" # Broken tarball for this version

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc flac ogg pulseaudio sdl sndfile static vorbis zlib"

RDEPEND="
	media-sound/mpg123
	sys-devel/libtool
	flac? ( media-libs/flac )
	ogg? ( media-libs/libogg )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl )
	sndfile? ( media-libs/libsndfile )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		$(use_enable static) \
		$(use_with flac) \
		$(use_with ogg) \
		$(use_with vorbis) \
		$(use_with pulseaudio) \
		$(use_with sdl sdl2) \
		$(use_with sndfile) \
		$(use_with zlib) \
		--enable-libopenmpt_modplug \
		--libdir=/usr/$(get_libdir)
}

src_install() {
	emake DESTDIR="$D" install
	dodoc README.md TODO libopenmpt/dox/*
}
