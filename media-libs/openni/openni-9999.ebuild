# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/openni/openni-9999.ebuild,v 1.2 2011/10/31 09:16:53 frostwork Exp $

EAPI=4

inherit eutils git-2 multilib

MY_PN="OpenNI"
DESCRIPTION="opensource part of primesense kinect drivers"
HOMEPAGE="https://github.com/${MY_PN}/${MY_PN}"
EGIT_REPO_URI="git://github.com/${MY_PN}/${MY_PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc graphviz"

DEPEND="dev-libs/libusb
	media-libs/freeglut
	graphviz? ( media-gfx/graphviz )
	doc? ( app-doc/doxygen )
	virtual/jpeg"
#	dev-libs/tinyxml"
RDEPEND="${DEPEND}"

src_prepare() {
	if use !doc; then
	sed -i -e "s:execute_check(\"doxygen:#execute_check(\"doxygen:g" -i Platform/Linux/CreateRedist/Redist_OpenNi.py
	fi
	epatch "${FILESDIR}"/libgl.patch 
}

src_compile() {
	cd ${WORKDIR}/${P}/Platform/Linux/Build
#	parallel build fails as lOpenNI is references before it exists
	emake -j1 redist || die "emake failed"
}

src_install() {
	cd ${WORKDIR}/${P}/Platform/Linux/Bin/x64-Release
	
	libdir=$(get_libdir)
	dodir /usr/${libdir}
	insinto /usr/${libdir}
	doins *.so || die
	
	insinto /usr/include/ni/
	doins -r ../../../../Include/* || die

	insinto /usr/bin/
	exeinto /usr/bin/
	doexe ni* || die
	doexe NiViewer* || die

	dodir /var/lib/ni
# todo mono and java?
}

pkg_postinst() {
	MODULES="libnimMockNodes.so libnimCodecs.so libnimRecorder.so"
	for module in $MODULES; do
		printf "registering module '$module'..."
		/usr/bin/niReg -r /usr/lib/$module
		printf "OK\n"
	done
}
