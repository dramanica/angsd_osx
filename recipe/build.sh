#!/usr/bin/env bash
set -euxo pipefail

# conda-build checks out git_url sources but does not guarantee that
# submodules are populated. ANGSD's default Makefile target also runs this,
# but doing it explicitly makes the build state clear.
git submodule update --init --recursive

# Build ANGSD using the bundled HTSlib submodule.
#
# Do NOT set HTSSRC=systemwide:
# leaving HTSSRC undefined selects ANGSD's submodule build path.
#
# Pass the Conda toolchain explicitly. HTSlib inherits CC through make.
make \
    CC="${CC}" \
    CXX="${CXX}" \
    CPPFLAGS="${CPPFLAGS}" \
    CFLAGS="${CFLAGS}" \
    CXXFLAGS="${CXXFLAGS}" \
    LDFLAGS="${LDFLAGS}"

# ANGSD's install-all target installs angsd and the programs under misc/.
make \
    CC="${CC}" \
    CXX="${CXX}" \
    prefix="${PREFIX}" \
    install-all
