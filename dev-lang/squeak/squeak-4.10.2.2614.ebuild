# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/squeak/Attic/squeak-3.9.7.ebuild,v 1.6 2009/08/10 16:03:42 vostorga dead $

inherit multilib base versionator fixheadtails

DESCRIPTION="Highly-portable Smalltalk-80 implementation"
HOMEPAGE="http://www.squeak.org/"
SRC_URI="http://squeakvm.org/unix/release/Squeak-${PV}-src.tar.gz"
LICENSE="Apple"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X mmx threads iconv"

ABI="32"

DEPEND="X? ( x11-libs/libX11 x11-libs/libXext x11-libs/libXt )"
RDEPEND="${DEPEND}"
#	virtual/squeak-image"

S="${WORKDIR}/Squeak-${PV}-src"

src_unpack() {
	base_src_unpack
	cd ${S}
	ht_fix_all
}

src_compile() {
	local myconf=""
	use X || myconf="--without-x"
	use mmx && myconf="${myconf} --enable-mpg-mmx"
	use threads && myconf="${myconf} --enable-mpg-pthread"
	use iconv || myconf="${myconf} --disable-iconv"
	cd ${S}
	mkdir build
	cd build
	../unix/cmake/configure \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--with-ffi=x86-sysv \
		${myconf} || die "configure failed"
	emake || die
}

src_install() {
	cd ${S}/build
	make ROOT=${D} docdir=/usr/share/doc/${PF} install || die
	exeinto /usr/lib/squeak
	doexe inisqueak
	dosym /usr/lib/squeak/inisqueak /usr/bin/inisqueak
}

pkg_postinst() {
	elog "Run 'inisqueak' to get a private copy of the squeak image."
}
