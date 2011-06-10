# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit font

DESCRIPTION="ParaType font collection for languages of Russia"
HOMEPAGE="http://fonts.ru/public/"
SRC_URI="http://www.fontstock.com/public/PTSans.zip"

LICENSE="ParaType"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"

