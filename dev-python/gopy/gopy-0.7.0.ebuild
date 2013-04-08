# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Extend CPython by writing Go"
HOMEPAGE="http://gopy.qur.me/extensions/"
SRC_URI="http://gopy.qur.me/extensions/${P}.tgz"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""
RDEPEND="virtual/libffi
         dev-lang/go
		 dev-lang/python:2.7"
DEPEND="${RDEPENDS}"

src_unpack() {
    unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/ffi-cflags.patch
}


