# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/minibufexpl/minibufexpl-6.4.3.ebuild,v 1.5 2012/04/17 16:04:29 ranger Exp $

EAPI=4

inherit git-2 vim-plugin

DESCRIPTION="This plugin will alternate between relative numbering (normal mode) and absolute numbering (insert mode) depending on the mode you are in."
HOMEPAGE="https://github.com/myusuf3/numbers.vim"
SRC_URI=""

EGIT_REPO_URI="git://github.com/myusuf3/numbers.vim.git"
EGIT_PROJECT="vim-numbers"
EGIT_BRANCH="master"

LICENSE="pd"
KEYWORDS=""
IUSE=""

VIM_PLUGIN_HELPFILES="numbers.txt"

src_prepare() {
	# Discard unwanted files
	rm .gitignore README.md || die
}
