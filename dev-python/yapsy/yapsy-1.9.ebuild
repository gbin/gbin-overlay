# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

DESCRIPTION="Yapsy is a small library implementing the core mechanisms needed to build a plugin system into a wider application."
HOMEPAGE="http://yapsy.sourceforge.net/"
SRC_URI="mirror://sourceforge/yapsy/Yapsy-${PV}/Yapsy-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/Yapsy-${PV}"

src_compile() {
	distutils_src_compile
}
        
src_install() {
	distutils_src_install
}
                                        
DOCS="PKG-INFO README.txt"
