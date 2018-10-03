# Lies!  Lies and Slander!  Supposedly ccache doesn't make things fail, but
# WHAT DO WE HAVE?! Literal proof that this is not the case.  This whole thing
# fails to do the proper symbol renaming with `ccache`, which is TERRIBLE.
ENV["BINARYBUILDER_USE_CCACHE"] = "false"
using BinaryBuilder

# Collection of sources required to build ArpackBuilder
name = "ArpackBuilder"
version = v"3.5.0-2"
sources = [
    "https://github.com/opencollab/arpack-ng.git" =>
    "f532cc06a164a5e9f5ba7e05d1b5ad415a6fdc47",
]


# Bash recipe for building across all platforms
script = raw"""

cd $WORKSPACE/srcdir
mkdir arpack-build
cd arpack-build

# arpack tests require finding libgfortran when linking with C linkers,
# and gcc doesn't automatically add that search path.  So we do it for it.
EXE_LINK_FLAGS="${LDFLAGS}"
if [[ ${target} != *darwin* ]]; then
    EXE_LINK_FLAGS="${EXE_LINK_FLAGS} -Wl,-rpath-link,/opt/${target}/${target}/lib -Wl,-rpath-link,/opt/${target}/${target}/lib64"
fi

# Symbols that have float32, float64, complexf32, and complexf64 support
SDCZ_SYMBOLS="axpy copy gemv geqr2 lacpy lahqr lanhs larnv lartg \
              lascl laset scal trevc trmm trsen gbmv gbtrf gbtrs \
              gttrf gttrs pttrf pttrs"

# All symbols that have float32/float64 support (including the SDCZ_SYMBOLS above)
SD_SYMBOLS="${SDCZ_SYMBOLS} dot ger labad laev2 lamch lanst lanv2 \
            lapy2 larf larfg lasr nrm2 orm2r rot steqr swap"

# All symbols that have complexf32/complexf64 support (including the SDCZ_SYMBOLS above)
CZ_SYMBOLS="${SDCZ_SYMBOLS} dotc geru unm2r"

# Add in (s|d)*_64 symbol remappings:
for sym in ${SD_SYMBOLS}; do
    SYMBOL_DEFS="${SYMBOL_DEFS} -Ds${sym}=s${sym}_64 -Dd${sym}=d${sym}_64"
done

# Add in (c|z)*_64 symbol remappings:
for sym in ${CZ_SYMBOLS}; do
    SYMBOL_DEFS="${SYMBOL_DEFS} -Dc${sym}=c${sym}_64 -Dz${sym}=z${sym}_64"
done

# Add one-off symbol mappings; things that don't fit into any other bucket:
for sym in scnrm2 dznrm2 csscal zdscal dgetrf dgetrs; do
    SYMBOL_DEFS="${SYMBOL_DEFS} -D${sym}=${sym}_64"
done

# Set up not only lowercase symbol remappings, but uppercase as well:
SYMBOL_DEFS="${SYMBOL_DEFS} ${SYMBOL_DEFS^^}"

FFLAGS="${FFLAGS} -O2 -fPIC -ffixed-line-length-none -cpp"
LIBOPENBLAS=openblas
if [[ ${nbits} == 64 ]]; then
    LIBOPENBLAS=openblas64_
    FFLAGS="${FFLAGS} -fdefault-integer-8 ${SYMBOL_DEFS}"
fi

cmake ../arpack-ng -DCMAKE_INSTALL_PREFIX="$prefix" -DCMAKE_TOOLCHAIN_FILE="/opt/$target/$target.toolchain" -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES="-L$prefix/lib -l${LIBOPENBLAS}" -DLAPACK_LIBRARIES="-L$prefix/lib -l${LIBOPENBLAS}" -DCMAKE_Fortran_FLAGS="${FFLAGS}" -DCMAKE_EXE_LINKER_FLAGS="${EXE_LINK_FLAGS}"

make -j${nproc} VERBOSE=1
make install VERBOSE=1

# For now, we'll have to adjust the name of the OpenBLAS library on macOS.
# Eventually, this should be fixed upstream
if [[ ${target} == "x86_64-apple-darwin14" ]]; then
    echo "-- Modifying library name for OpenBLAS"
    install_name_tool -change libopenblas64_.0.3.0.dylib @rpath/libopenblas64_.dylib ${prefix}/lib/libarpack.2.0.0.dylib
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line.  We enable the full
# combinatorial explosion of GCC versions because this package most
# definitely links against libgfortran.
platforms = expand_gcc_versions(supported_platforms())

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libarpack", :Arpack)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaLinearAlgebra/OpenBLASBuilder/releases/download/v0.3.0-3/build_OpenBLAS.v0.3.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

