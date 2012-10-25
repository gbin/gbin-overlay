# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="Twilio API client and TwiML generator"
HOMEPAGE="http://github.com/twilio/twilio-python/"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND="dev-python/pyjwt"

S="${WORKDIR}/twilio-${PV}"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

