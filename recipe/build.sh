#!/usr/bin/env bash

set -euxo pipefail


# Locate extracted source
cd "${SRC_DIR}"


# Build bundled HTSlib
cd htslib

make \
    CC="${CC}" \
    CFLAGS="${CFLAGS}" \
    LDFLAGS="${LDFLAGS}"

cd ../angsd


# Build ANGSD against bundled HTSlib
#
# This is the upstream-recommended mechanism:
# make HTSSRC=../htslib

export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include -I${SRC_DIR}/htslib"
export CFLAGS="${CFLAGS} -I${PREFIX}/include -I${SRC_DIR}/htslib -Xpreprocessor -fopenmp"
export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include -I${SRC_DIR}/htslib -Xpreprocessor -fopenmp"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -lomp"


make \
    HTSSRC=../htslib \
    CC="${CC}" \
    CXX="${CXX}" \
    CPPFLAGS="${CPPFLAGS}" \
    CFLAGS="${CFLAGS}" \
    CXXFLAGS="${CXXFLAGS}" \
    LDFLAGS="${LDFLAGS}"


mkdir -p "${PREFIX}/bin"

install -m 755 angsd "${PREFIX}/bin/"


# Install auxiliary programs

for exe in \
    misc/realSFS \
    misc/thetaStat
do
    if [ -f "${exe}" ]; then
        install -m 755 "${exe}" "${PREFIX}/bin/"
    fi
done
