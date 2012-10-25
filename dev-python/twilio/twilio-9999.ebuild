# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit distutils eutils git-2 user

PYTHON_DEPEND="2:2.7 3:3.2"
SUPPORT_PYTHON_ABIS="1"

DESCRIPTION="Twilio API client and TwiML generator"
HOMEPAGE="http://github.com/twilio/twilio-python/"
SRC_URI=""

# this will be changed when the python3 support will be merged in
EGIT_BRANCH="python3"
EGIT_REPO_URI="git@github.com:gbin/twilio-python.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"
DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/twilio-${PV}"

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}

