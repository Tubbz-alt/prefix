# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXML/XML-LibXML-1.65.ebuild,v 1.3 2007/12/11 09:56:15 vapier Exp $

EAPI="prefix"

inherit perl-module eutils versionator

MY_P="${PN}-$(delete_version_separator 2)"
S=${WORKDIR}/$PN-$(get_version_component_range "1-2" $PV)

DESCRIPTION="A Perl module to parse XSL Transformational sheets using gnome's libXSLT"
HOMEPAGE="http://search.cpan.org/~pajas/"
SRC_URI="mirror://cpan/authors/id/P/PA/PAJAS/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~mips ~ppc-macos ~sparc-solaris ~x86 ~x86-macos"
IUSE=""

DEPEND=">=dev-perl/XML-SAX-0.12
	dev-perl/XML-LibXML-Common
	>=dev-libs/libxml2-2.6.6
	>=dev-perl/XML-NamespaceSupport-1.07
	dev-lang/perl"

SRC_TEST="do"

# rac can't discern any difference between the build with or without
# this, and if somebody wants to reactivate it, get it out of global
# scope.
#export PERL5LIB=`perl -e 'print map { ":$ENV{D}/$_" } @INC'`
mytargets="pure_install doc_install"

pkg_postinst() {
	perl-module_pkg_postinst
	perl -MXML::SAX \
		-e "XML::SAX->add_parser(q(XML::LibXML::SAX::Parser))->save_parsers()"
}
