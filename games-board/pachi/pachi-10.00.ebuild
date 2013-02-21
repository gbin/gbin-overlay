# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnugo/gnugo-3.9.1.ebuild,v 1.6 2012/12/24 12:10:51 maekke Exp $

EAPI=5
inherit games
inherit git-2

DESCRIPTION="Pachi Simple Go/Baduk/Weiqi Bot"
HOMEPAGE="http://pachi.or.cz/"
EGIT_REPO_URI="git://repo.or.cz/pachi.git"
EGIT_BRANCH="${P}-satsugen"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install()
{
	mkdir -p ${D}/usr/local/bin
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc COPYING CREDITS README HACKING || die
}
