# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Params-Util/Params-Util-0.37.ebuild,v 1.1 2009/02/05 13:13:36 tove Exp $

EAPI="prefix"

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Utility functions to aid in parameter checking"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND=">=virtual/perl-Scalar-List-Utils-1.18
	dev-lang/perl"
RDEPEND="${DEPEND}"

SRC_TEST="do"
