# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibALSABuilder"
version = v"1.1.6"

# Collection of sources required to build LibALSABuilder
sources = [
    "ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.1.6.tar.bz2" =>
    "5f2cd274b272cae0d0d111e8a9e363f08783329157e8dd68b3de0c096de6d724",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd alsa-lib-1.1.6/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libasound", :libasound)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

