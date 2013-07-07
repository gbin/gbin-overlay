# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Extend CPython by writing Go"
HOMEPAGE="http://gopy.qur.me/extensions/"
SRC_URI="https://github.com/qur/gopy/archive/ext.tar.gz"


LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT=""
RDEPEND="virtual/libffi
         dev-lang/go
		 dev-lang/python:2.7"
DEPEND="${RDEPENDS}"
S="${S}/gccgo"

src_unpack() {
    unpack ext.tar.gz
	mv gopy-ext gopy-9999
	cd "${S}"
}


