# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit eutils git python

MY_PN="${PN/s/S}"
MY_PN="${MY_PN/b/B}"

DESCRIPTION="TV shows PVR & episode guide"
HOMEPAGE="http://github.com/midgetspy/${MY_PN}"
SRC_URI=""

EGIT_REPO_URI="http://github.com/midgetspy/${MY_PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-python/cherrypy-3.2.0_rc1
	dev-python/cheetah
	net-nntp/sabnzbd"
RESTRICT_PYTHON_ABIS="2.4 3.*"

DOCS=( "COPYING.txt" "readme.md" )

src_install() {
	# Init script
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	# Install
	dodir /usr/lib/${PN}
	insinto /usr/lib/${PN}

	for sickb_dir in autoProcessTV data lib sickbeard ; do
		doins -r ${sickb_dir} || die "failed to install ${sickb_dir}"
	done
	doins SickBeard.py || die "failed to install SickBeard.py"

	# Create run, log & cache directories
	for sickb_runtime_dir in run log cache ; do
		keepdir /var/${sickb_runtime_dir}/${PN}
		fowners -R sabnzbd:sabnzbd /var/${sickb_runtime_dir}/${PN}
		fperms -R 775 /var/${sickb_runtime_dir}/${PN}
	done

	# Install bare-bone config file (NOTE: AFAICT, sickbeard will *always* look for it in its basedir...)
	insinto /usr/lib/${PN}
	newins "${FILESDIR}/config.ini" "config.ini"
	fowners root:sabnzbd /usr/lib/${PN}/config.ini
	fperms 660 /usr/lib/${PN}/config.ini

	# Fix perms
	fowners -R root:sabnzbd /usr/lib/${PN}
	fperms -R 775 /usr/lib/${PN}
}

#pkg_postinst() {
# Optimize
#python_mod_optimize "/usr/lib/${PN}"
#}
