# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

EGIT_REPO_URI="git://github.com/gbin/err.git"
if [ "${PV}" = "9999" ]; then
		inherit git-2
fi

RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="err is a plugin based XMPP chatbot designed to be easily deployable, extensible and maintainable."
HOMEPAGE="http://gbin.github.com/err/"

if [ "${PV}" != "9999" ]; then
	SRC_URI="http://pypi.python.org/packages/source/e/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-python/setuptools"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_pkg_setup
	enewgroup 'err'
	enewuser 'err' -1 -1 -1 'err'
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/errd.initd errd
	newconfd "${FILESDIR}"/errd.confd errd
	mkdir -p "${D}"etc/err
	mkdir -p "${D}"var/lib/err
	mkdir -p "${D}"var/log/err
	mkdir -p "${D}"var/run/err
	fowners -R err:err /var/lib/err/
	fowners -R err:err /var/log/err/
	fowners -R err:err /var/run/err/
	insinto /etc/err/
	newins errbot/config-template.py config.py
}

