# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-xetex/Attic/texlive-xetex-2008.ebuild,v 1.1 2008/09/09 16:54:57 aballier Exp $

EAPI="prefix"

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
!=app-text/texlive-core-2007*
"
TEXLIVE_MODULE_CONTENTS="arabxetex euenc bidi fontspec fontwrap ifxetex philokalia polyglossia xecyr xepersian xetex xetex-def xetex-pstricks xetexconfig xetexfontinfo xltxtra xunicode collection-xetex
"
TEXLIVE_MODULE_DOC_CONTENTS="arabxetex.doc euenc.doc bidi.doc fontspec.doc fontwrap.doc ifxetex.doc philokalia.doc polyglossia.doc xecyr.doc xepersian.doc xetex.doc xetex-pstricks.doc xetexfontinfo.doc xltxtra.doc xunicode.doc "
TEXLIVE_MODULE_SRC_CONTENTS="euenc.source bidi.source fontspec.source philokalia.source polyglossia.source xltxtra.source "
inherit texlive-module
DESCRIPTION="TeXLive XeTeX packages"

LICENSE="GPL-2 Apache-2.0 as-is GPL-1 LPPL-1.3 OFL public-domain "
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""
