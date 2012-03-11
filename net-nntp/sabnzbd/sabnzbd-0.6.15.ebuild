# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="3"
PYTHON_DEPEND="2:2.6"

inherit eutils python

MY_P="$P"
MY_P="${MY_P/sab/SAB}"
MY_P="${MY_P/_beta/Beta}"
MY_P="${MY_P/_rc/RC}"


DESCRIPTION="Binary Newsgrabber written in Python, server-oriented using a web-interface."
HOMEPAGE="http://www.${PN}.org/"
SRC_URI="mirror://sourceforge/${PN}plus/${MY_P}-src.tar.gz"

HOMEDIR="${ROOT}var/lib/${PN}"
DHOMEDIR="/var/lib/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+rar zip rss +yenc ssl -cherrypy"

RDEPEND="dev-python/pysqlite:2
	dev-python/celementtree
	cherrypy? ( >=dev-python/cherrypy-3.2.0 )
	dev-python/cheetah
	app-arch/par2cmdline
	rar? ( app-arch/unrar )
	zip? ( app-arch/unzip )
	rss? ( dev-python/feedparser )
	yenc? ( dev-python/python-yenc )
	ssl? ( dev-python/pyopenssl )"
DEPEND="${RDEPEND}
	app-text/dos2unix"

S="${WORKDIR}/${MY_P}"
DOCS=( "CHANGELOG.txt" "ISSUES.txt" "INSTALL.txt" "README.txt" "Sample-PostProc.sh" )

pkg_setup() {
	# Create group and user
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${HOMEDIR}" "${PN}"

	python_set_active_version 2
}

get_key() {
	local mypy len
	len=24
	mypy="import string;"
	mypy="$mypy from random import Random;"
	mypy="$mypy print ''.join(Random().sample(string.letters+string.digits, ${len}));"
	python -c "$mypy"
}

src_prepare() {
	# Fix SSL support with latest CherryPy releases (deprecation warning in 3.2.0, broken in 3.2.1)
	use cherrypy && epatch "${FILESDIR}/${PN}-0.6.9-cherrypy-3.2.1-compat.patch"
}

src_install() {
	api_key=$(get_key)
	ewarn "Setting api key to: ${api_key}"


	# Init scripts
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	newinitd "${FILESDIR}/${PN}.init" "${PN}"

	# Example config
	cp "${FILESDIR}/${PN}.ini" .
	sed -e "s/%API_KEY%/${api_key}/g" -i "${PN}.ini"
	insinto /etc/${PN}
	newins "${PN}.ini" "${PN}.conf"
	fowners -R root:${PN} /etc/${PN}
	fperms -R 660 /etc/${PN}
	fperms 660 /etc/conf.d/${PN}

	# Create all default dirs
	keepdir ${DHOMEDIR}

	for i in download dirscan complete incomplete nzb_backup cache scripts admin ; do
		keepdir ${DHOMEDIR}/${i}
	done
	fowners -R ${PN}:${PN} ${DHOMEDIR}
	fperms -R 775 ${DHOMEDIR}

	keepdir /var/log/${PN}
	fowners -R ${PN}:${PN} /var/log/${PN}
	fperms -R 775 /var/log/${PN}

	keepdir /var/run/${PN}
	fowners -R root:${PN} /var/run/${PN}
	fperms -R 770 /var/run/${PN}

	# Build locales
	python tools/make_mo.py

	# Add themes & code
	dodir /usr/lib/${PN}
	insinto /usr/lib/${PN}
	for sab_dir in email gntp interfaces ${PN} locale util ; do
		doins -r ${sab_dir} || die "failed to install ${sab_dir}"
	done
	use cherrypy || doins -r cherrypy || die "failed to install cherrypy"
	doins SABnzbd.py || die "installing SABnzbd.py"

	# Fix permissions
	fowners -R root:${PN} /usr/lib/${PN}
	fperms -R 775 /usr/lib/${PN}
}

pkg_postinst() {

	# optimizing
	python_mod_optimize "/usr/lib/${PN}"

	einfo "Default directory: ${HOMEDIR}"
	einfo "Templates can be found in: ${ROOT}usr/lib/${PN}"
	einfo ""
	einfo "Run: gpasswd -a <user> ${PN}"
	einfo "to add an user to the ${PN} group so it can edit ${PN} files"
	einfo ""
	ewarn "Please configure /etc/conf.d/${PN} before starting!"
	einfo ""
	einfo "Start with ${ROOT}etc/init.d/${PN} start"
	einfo "Default web credentials : ${PN}/secret"
	einfo ""
	ewarn "When upgrading ${PN}, don't forget to fix the permissions"
	ewarn "on the config file after merging the changes."
	ewarn ""
	ewarn "chown -cvR root:${PN} /etc/${PN} && chmod -cvR 660 /etc/${PN}"
}
