# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 autotools-utils

DESCRIPTION="fuse-google-drive is a fuse filesystem wrapper for Google Drive"
HOMEPAGE="https://github.com/jcline/fuse-google-drive/blob/master/README"

EGIT_REPO_URI="git://github.com/jcline/fuse-google-drive.git"

LICENSE="GPLv2"
KEYWORDS=""
SLOT="0"
IUSE=""

COMMON_DEPEND="sys-fs/fuse
net-misc/curl
<dev-libs/json-c-0.10
dev-libs/libxml2"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_prepare() {
	eautoreconf
}

