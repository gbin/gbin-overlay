# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/yapsy/yapsy-1.9.2.ebuild,v 1.3 2012/09/18 13:25:00 johu Exp $
EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3} )

inherit distutils-r1 python-r1

DESCRIPTION="Modern, multi-threaded and extensible web server."
HOMEPAGE="http://launchpad.net/rocket"
SRC_URI="mirror://pypi/r/rocket/Rocket-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="dev-python/setuptools"
RDEPEND=""
S="${WORKDIR}/Rocket-${PV}"
