# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "igraphBuilder"
version = v"0.0.1"

# Collection of sources required to build igraphBuilder
sources = [
    "https://github.com/igraph/igraph/releases/download/0.7.1/igraph-0.7.1.tar.gz" =>
    "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd igraph-0.7.1/
./configure --prefix=$prefix --host=$target
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
#    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libigraph", :libigraph)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/build_Zlib.v1.2.11.jl",
    "https://github.com/bicycle1885/XML2Builder/releases/download/v1.0.2/build_XML2Builder.v2.9.9.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

