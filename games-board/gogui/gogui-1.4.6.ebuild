# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games java-pkg-2 java-ant-2 gnome2

DESCRIPTION="Graphical interface to programs that play the game of Go and use the Go Text Protocol (GTP)"
HOMEPAGE="http://gogui.sourceforge.net/"
SRC_URI="mirror://sourceforge/gogui/${PV}/${P}-src.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

EANT_BUILD_TARGET="build"
EANT_EXTRA_ARGS="-Ddocbook-xsl.dir=/usr/share/sgml/docbook/xsl-stylesheets \
-Ddocbook.dtd-4.2=/usr/share/sgml/docbook/xml-dtd-4.2/docbookx.dtd \
-Dquaqua.ignore=true"

src_configure() {
	return 0
}

src_compile() {
	ant "$EANT_BUILD_TARGET" $EANT_EXTRA_ARGS
}

src_install() {
	java-pkg_dojar lib/*
	for l in `ls bin`; do
		java-pkg_dolauncher $l --jar $l.jar
	done
	dodoc doc/manual/html/*.html
	doman doc/manual/man/*.1

	cd config
	insinto /usr/share/icons/hicolor/48x48/apps
	doins gogui-gogui.png
	insinto /usr/share/icons/hicolor/48x48/mimetypes
	doins application-x-go-sgf.png
	insinto /usr/share/applications
	doins gogui-gogui.desktop
	insinto /usr/share/mime/application
	doins gogui-mime.xml
	insinto /etc/gconf/schemas
	doins gogui.schemas
	insinto /usr/share/omf/gogui
}
