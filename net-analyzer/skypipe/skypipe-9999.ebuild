# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/err/err-9999.ebuild,v 1.2 2012/06/26 16:51:34 maksbotan Exp $

EAPI=4

EGIT_REPO_URI="git://github.com/progrium/skypipe.git"

DISTUTILS_SRC_TEST="setup.py"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils git-2 user

DESCRIPTION="Skypipe is a magical command line tool that lets you easily pipe data across terminal sessions, regardless of whether the sessions are on the same machine, across thousands of machines, or even behind a firewall. It gives you named pipes in the sky and lets you magically pipe data anywhere."

HOMEPAGE="https://github.com/progrium/skypipe"

SRC_URI=""
KEYWORDS=""
LICENSE="MIT"
SLOT="0"

DEPEND="dev-python/setuptools"
RDEPEND="virtual/python-argparse
	dev-python/pyzmq
	dev-python/requests
    dev-python/colorama
"

src_prepare() {
    epatch "${FILESDIR}"/unstatic-pyzmq-9999.patch
}
