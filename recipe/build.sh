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

# Install everything defined by upstream
make \
    HTSSRC=../htslib \
    bindir="${PREFIX}/bin" \
    install-all
