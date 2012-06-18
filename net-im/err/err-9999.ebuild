# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://github.com/gbin/err.git"

DISTUTILS_SRC_TEST="setup.py"

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils git-2 user

DESCRIPTION="err is a plugin based XMPP chatbot designed to be easily deployable, extensible and maintainable."
HOMEPAGE="http://gbin.github.com/err/"

SRC_URI=""
KEYWORDS=""
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND="dev-python/xmpppy
	dev-python/python-daemon
	dev-python/yapsy"

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/errd.initd errd
	newconfd "${FILESDIR}"/errd.confd errd
	dodir /etc/err
	dodir /var/lib/err
	keepdir /var/log/err
	keepdir /var/run/err
	fowners -R err:err /var/lib/err/
	fowners -R err:err /var/log/err/
	fowners -R err:err /var/run/err/
	insinto /etc/err/
	newins errbot/config-template.py config.py
}

pkg_setup() {
	python_pkg_setup
	ebegin "Creating err group and user"
	enewgroup 'err'
	enewuser 'err' -1 -1 -1 'err'
	eend ${?}
}
