# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/drod-bin/drod-bin-1.6.7.ebuild,v 1.4 2013/01/27 08:31:06 tupone Exp $

EAPI=2

inherit eutils games

DESCRIPTION="MoGo is a computer software dedicated to computer-Go."
HOMEPAGE="https://www.lri.fr/~teytaud/mogo.html"
SRC_URI="http://www.lri.fr/~teytaud/mogor"

LICENSE="not specified"

SLOT="0"
KEYWORDS="-* ~amd64 x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND=""
#RDEPEND="
#	amd64? (
#		app-emulation/emul-linux-x86-compat
#	)"

GDIR=${GAMES_PREFIX_OPT}/mogo
QA_PREBUILT="${GDIR:1}/mogor"

S="${WORKDIR}"

src_unpack() {
	cp ${DISTDIR}/${A} .
}

src_configure() {
	chmod a+x mogor
}

src_install() {
	insinto "${GDIR}"
	exeinto "${GDIR}"
	doexe mogor
	dogamesbin mogor
	prepgamesdirs
}

