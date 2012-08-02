# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://www.plkr.org/"
SRC_URI="http://downloads.plkr.org/${PV}/plucker-${PV}-1.i386.rpm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND="app-arch/rpm"
RDEPEND=">=dev-lang/python-2.2"
#S=${WORKDIR}/${P}

src_install() {
	cd "${D}"
	rpm2cpio "${DISTDIR}/${A}" | cpio -id
	pyversion=`python2 -c 'import sys;print sys.version[:3]'`
	pydir=usr/lib/python${pyversion}
	mv usr/lib/python ${pydir}
	python2 -c "import compileall; compileall.compile_dir('${pydir}', 4, '/${pydir}')"
	dosym ../lib/python${pyversion}/site-packages/PyPlucker/Spider.py /usr/bin/plucker-build
	dosym ../lib/python${pyversion}/site-packages/PyPlucker/PluckerDocs.py /usr/bin/plucker-decode
	dosym ../lib/python${pyversion}/site-packages/PyPlucker/Decode.py /usr/bin/plucker-dump
}
