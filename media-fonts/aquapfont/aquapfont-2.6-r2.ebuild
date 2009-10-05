# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/aquapfont/aquapfont-2.6-r2.ebuild,v 1.5 2009/10/04 19:21:37 klausman Exp $

inherit font

MY_P="${PN/font/}${PV/\./_}"

DESCRIPTION="Very pretty Japanese proportional truetype font"
HOMEPAGE="http://aquablue.milkcafe.to/"
SRC_URI="http://aquablue.milkcafe.to/tears/font/${MY_P}.zip"

LICENSE="aquafont"
SLOT="0"
KEYWORDS="~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="readme.txt"

DEPEND="app-arch/unzip"
RDEPEND=""

# Only installs fonts
RESTRICT="strip binchecks"

FONT_CONF=( "${T}/60-aquapfont.conf" )

src_compile() {
	cp "${FILESDIR}"/60-aquapfont-r1.conf "${T}"/60-aquapfont.conf || die
}

pkg_postinst() {
	font_pkg_postinst

	echo
	elog "To use aquapfont instead of the default font for sans and serif use:"
	elog "   eselect fontconfig enable 60-aquapfont.conf"
	echo
}
