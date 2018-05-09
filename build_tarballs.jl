using BinaryBuilder

# Collection of sources required to build ArpackBuilder
sources = [
    "https://github.com/opencollab/arpack-ng.git" =>
    "b095052372aa95d4281a645ee1e367c28255c947",

    "https://github.com/Reference-LAPACK/lapack.git" =>
    "ba3779a6813d84d329b73aac86afc4e041170609",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
mkdir lapack-build
cd lapack-build
cmake ../lapack -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_SHARED_LIBS=ON
make -j install
cd ..
mkdir arpack-build
cd arpack-build
cmake ../arpack-ng -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_SHARED_LIBS=ON -DEXAMPLES=ON
make -j install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
#    BinaryProvider.Linux(:powerpc64le, :glibc, :blank_abi),
#    BinaryProvider.Linux(:i686, :musl, :blank_abi),
#    BinaryProvider.Linux(:x86_64, :musl, :blank_abi),
#    BinaryProvider.Linux(:aarch64, :musl, :blank_abi),
#    BinaryProvider.Linux(:armv7l, :musl, :eabihf),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libblas", :BLAS),
    LibraryProduct(prefix, "liblapack", :LAPACK),
    LibraryProduct(prefix, "libarpack", :ARPACK)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ArpackBuilder", sources, script, platforms, products, dependencies)

