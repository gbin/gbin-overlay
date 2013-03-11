# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-medialibs/emul-linux-x86-medialibs-20130224.ebuild,v 1.1 2013/02/25 18:44:44 pacho Exp $

EAPI=5
SLOT="0"

S="${WORKDIR}/Squeak-4.10.2.2614-linux_i386"
EXE="${S}/lib/squeak/4.10.2-2614/squeakvm"

LICENSE="APL-1.0 GPL-2 BSD BSD-2 public-domain LGPL-2 MPL-1.1 LGPL-2.1 MPEG-4"
KEYWORDS="-* ~amd64"
SRC_URI="http://www.squeakvm.org/unix/release/Squeak-4.10.2.2614-linux_i386.tar.gz"
DEPEND=""
RDEPEND="app-emulation/emul-linux-x86-baselibs"
PDEPEND=""

src_install() {
	exeinto /usr/local/bin
	doexe ${EXE} 
	rm ${EXE} 
	insinto /usr/lib32/squeak
	insopts -m755 
	doins "${S}/lib/squeak/4.10.2-2614/"*
    doman "share/man/man1/"* 
	dodoc 
}

