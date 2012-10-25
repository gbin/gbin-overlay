# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="https://github.com/progrium/pyjwt"
SRC_URI="mirror://pypi/P/PyJWT/PyJWT-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND=""

S="${WORKDIR}/PyJWT-${PV}"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

