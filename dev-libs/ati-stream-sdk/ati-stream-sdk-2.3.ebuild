EAPI=3

DESCRIPTION="ATI OpenCL Stream SDK"
HOMEPAGE="http://developer.amd.com/gpu/ATIStreamSDK/Pages/default.aspx"
SRC_URI="http://download2-developer.amd.com/amd/Stream20GA/ati-stream-sdk-v${PV}-lnx64.tgz"

LICENSE="AMD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="|| ( =x11-drivers/ati-drivers-10.11 =x11-drivers/ati-drivers-10.12 )"

MY_P=ati-stream-sdk-v${PV}-lnx64
S=${WORKDIR}/${MY_P}

src_compile() {
	:
	# emake
}

src_install() {
	ROOT=/opt/ati-stream-sdk
	dodir ${ROOT}
	if use amd64 ; then
		arch=x86_64
	else
		arch=x86
	fi

	cp -a include lib samples ${D}${ROOT}
	dobin bin/${arch}/*

	dodir /usr/include
	cp -a include/*.h include/CL include/OVDecode ${D}/usr/include/

	dodir /etc/ld.so.conf.d
	echo ${ROOT}/lib/${arch} > ${D}/etc/ld.so.conf.d/ati-stream-sdk

	dodir /etc/env.d
	{
		if use amd64 ; then
			echo LDPATH=\"${ROOT}/lib/x86_64:${ROOT}/lib/x86\"
		else
			echo LDPATH=\"${ROOT}/lib/x86\"
		fi
		echo ATISTREAMSDKROOT=\"${ROOT}\"
		echo ATISTREAMSDKSAMPLESROOT=\"${ROOT}\"
		echo OPENCL_DIR=\"${ROOT}\"
	} > ${D}/etc/env.d/99ati-stream-sdk

	dodoc *.txt docs/opencl/*

	tar -xzf icd-registration.tgz -C ${D}
}
