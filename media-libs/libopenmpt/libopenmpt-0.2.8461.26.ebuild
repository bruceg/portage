# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

beta="${PV#*.*.*.}"
MV="${PV%.$beta}"
SV="${MV}-beta$beta"

DESCRIPTION="library to decode tracked music files (modules)"
HOMEPAGE="https://lib.openmpt.org/libopenmpt/"
SRC_URI="https://lib.openmpt.org/files/libopenmpt/src/${PN}-${SV}.tar.gz"
S="$WORKDIR/${PN}-${MV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc flac ogg pulseaudio sdl sndfile static vorbis zlib"

RDEPEND="
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

src_compile() {
	emake \
		$(use static && echo SHARED_LIB=0) \
		$(use flac || echo NO_FLAC=1) \
		$(use ogg || echo NO_OGG=1) \
		$(use pulseaudio || echo NO_PULSEAUDIO=1) \
		$(use sdl || echo NO_SDL=1 NO_SDL2=1) \
		$(use sndfile || echo NO_SNDFILE=1) \
		$(use vorbis || echo NO_VORBIS=1 NO_VORBISFILE=1) \
		$(use zlib || echo NO_ZLIB=1)
}

src_install() {
	emake DESTDIR="$D" PREFIX=/usr install
	dodoc README.md TODO libopenmpt/doc/* libopenmpt/dox/*
}
