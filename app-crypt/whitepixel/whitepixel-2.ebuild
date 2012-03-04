# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI=3

DESCRIPTION="GPU-accelerated password hash auditing software for AMD/ATI graphics cards"
HOMEPAGE="http://whitepixel.zorinaq.com/"
SRC_URI="http://whitepixel.zorinaq.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-util/ati-stream-sdk-bin"
DEPEND="dev-lang/perl"

src_unpack() {
        unpack ${A}
	cd "${S}"
        epatch "${FILESDIR}"/ati-Werror.patch
}

src_install() {
	emake whitepixel || die
	mv -vf whitepixel "${D}"/usr/bin/ || die
	dodoc LICENSE README
}
