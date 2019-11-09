# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SNMP MIB declaring the Hacking Networked Solutions namespace"
HOMEPAGE="https://github.com/GITHUB_REPOSITORY"
LICENSE="LGPL-3"

if [[ ${PV} = *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/GITHUB_REPOSITORY"
    EGIT_BRANCH="GITHUB_REF"
else
    SRC_URI="https://github.com/GITHUB_REPOSITORY/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="test"
SLOT="0"

RESTRICT="!test? ( test )"

RDEPEND="net-analyzer/net-snmp"
DEPEND="test? ( ${RDEPEND} net-libs/libsmi )"

src_test() {
    files=("usr/share/snmp/mibs/HACKING-SNMP-MIB.txt")
    exitval=0
    for f in ${files[*]}; do
        if (( $(smilint -s --level=4 "${f}" 2>&1 | wc -l ) > 0 )); then
            echo "${f} - failed tests"
            exitval=1
            smilint -s --level=4 "${f}" 2>&1
        fi
    done
    (( exitval > 0 )) && die "Tests failed"
}

src_install() {
    einstalldocs

    insinto /usr/share/snmp/mibs
    doins usr/share/snmp/mibs/*
}
