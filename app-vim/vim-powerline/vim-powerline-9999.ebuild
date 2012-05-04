# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/minibufexpl/minibufexpl-6.4.3.ebuild,v 1.5 2012/04/17 16:04:29 ranger Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="The ultimate vim statusline utility"
HOMEPAGE="https://github.com/Lokaltog/vim-powerline"
SRC_URI="https://github.com/Lokaltog/${PN}/tarball/develop/ -> ${P}.tar.gz"

LICENSE="ccs"
KEYWORDS="amd64"
IUSE=""

VIM_PLUGIN_HELPFILES="Powerline.txt"

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	# Discard unwanted files
	rm .gitignore README.rst || die
}
