# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils subversion

DESCRIPTION="Open Source Conditional Access Module software, based on MpCS version 0.9d"
HOMEPAGE="http://streamboard.gmc.to:8001/wiki/"
SRC_URI=""
ESVN_REPO_URI="http://streamboard.gmc.to/svn/oscam/trunk"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="anti-cascading doublecheck examples irdeto led loghistory pcsc stapi webif"

RDEPEND="dev-libs/openssl
	pcsc? ( sys-apps/pcsc-lite )
	dev-libs/libusb:1"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup oscam
	enewuser oscam -1 -1 -1 oscam
}

src_prepare() {
	subversion_src_prepare
	sed -i -e 's:\(CMAKE_EXE_LINKER_FLAGS\) "-s":\1 "":' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs="-DCS_CONFDIR=/etc/oscam -DCMAKE_VERBOSE_MAKEFILE=ON
		$(cmake-utils_use webif WEBIF)
		$(cmake-utils_use anti-cascading CS_ANTICASC)
		$(cmake-utils_use loghistory CS_LOGHISTORY)
		$(cmake-utils_use doublecheck CS_WITH_DOUBLECHECK)
		$(cmake-utils_use led CS_LED)
		$(cmake-utils_use stapi WITH_STAPI)
		$(cmake-utils_use irdeto IRDETO_GUESSING)
		$(cmake-utils_use pcsc CS_WITH_PCSC)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodir /etc/oscam || die
	fperms 0770 /etc/oscam
	fowners root:oscam /etc/oscam

	newinitd "${FILESDIR}/oscam.initd" oscam || die

	rm -rf "${D}"/usr/share/doc/

	if use examples; then
		docinto examples
		dodoc Distribution/doc/example/oscam.* || die
	fi
}

pkg_postinst() {
	einfo "Don't forget to add the 'oscam' user to the right groups, e.g. 'usb'"
	einfo "if you want use a usb reader or 'tty' for serial reader."
}
