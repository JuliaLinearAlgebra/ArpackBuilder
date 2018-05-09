using BinaryBuilder

# Collection of sources required to build ArpackBuilder
sources = [
    "https://github.com/opencollab/arpack-ng.git" =>
    "b095052372aa95d4281a645ee1e367c28255c947",

]


# Bash recipe for building across all platforms
script = raw"""

cd $WORKSPACE/srcdir
mkdir arpack-build
cd arpack-build

if [[ ${nbits} == 64 ]]; then
     cmake ../arpack-ng -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES="-L$prefix/lib -lopenblas64_" -DLAPACK_LIBRARIES="-L$prefix/lib -lopenblas64_" -DCMAKE_Fortran_FLAGS="-O2 -fPIC -ffixed-line-length-none -cpp -fdefault-integer-8 -Dsaxpy=saxpy_64 -Ddaxpy=daxpy_64  -Dscopy=scopy_64 -Ddcopy=dcopy_64  -Dsgemv=sgemv_64 -Ddgemv=dgemv_64  -Dsgeqr2=sgeqr2_64 -Ddgeqr2=dgeqr2_64  -Dslacpy=slacpy_64 -Ddlacpy=dlacpy_64  -Dslahqr=slahqr_64 -Ddlahqr=dlahqr_64  -Dslanhs=slanhs_64 -Ddlanhs=dlanhs_64  -Dslarnv=slarnv_64 -Ddlarnv=dlarnv_64  -Dslartg=slartg_64 -Ddlartg=dlartg_64  -Dslascl=slascl_64 -Ddlascl=dlascl_64  -Dslaset=slaset_64 -Ddlaset=dlaset_64  -Dsscal=sscal_64 -Ddscal=dscal_64  -Dstrevc=strevc_64 -Ddtrevc=dtrevc_64  -Dstrmm=strmm_64 -Ddtrmm=dtrmm_64  -Dstrsen=strsen_64 -Ddtrsen=dtrsen_64  -Dsgbmv=sgbmv_64 -Ddgbmv=dgbmv_64  -Dsgbtrf=sgbtrf_64 -Ddgbtrf=dgbtrf_64  -Dsgbtrs=sgbtrs_64 -Ddgbtrs=dgbtrs_64  -Dsgttrf=sgttrf_64 -Ddgttrf=dgttrf_64  -Dsgttrs=sgttrs_64 -Ddgttrs=dgttrs_64  -Dspttrf=spttrf_64 -Ddpttrf=dpttrf_64  -Dspttrs=spttrs_64 -Ddpttrs=dpttrs_64  -Dsdot=sdot_64 -Dddot=ddot_64  -Dsger=sger_64 -Ddger=dger_64  -Dslabad=slabad_64 -Ddlabad=dlabad_64  -Dslaev2=slaev2_64 -Ddlaev2=dlaev2_64  -Dslamch=slamch_64 -Ddlamch=dlamch_64  -Dslanst=slanst_64 -Ddlanst=dlanst_64  -Dslanv2=slanv2_64 -Ddlanv2=dlanv2_64  -Dslapy2=slapy2_64 -Ddlapy2=dlapy2_64  -Dslarf=slarf_64 -Ddlarf=dlarf_64  -Dslarfg=slarfg_64 -Ddlarfg=dlarfg_64  -Dslasr=slasr_64 -Ddlasr=dlasr_64  -Dsnrm2=snrm2_64 -Ddnrm2=dnrm2_64  -Dsorm2r=sorm2r_64 -Ddorm2r=dorm2r_64  -Dsrot=srot_64 -Ddrot=drot_64  -Dssteqr=ssteqr_64 -Ddsteqr=dsteqr_64  -Dsswap=sswap_64 -Ddswap=dswap_64  -Dcaxpy=caxpy_64 -Dzaxpy=zaxpy_64  -Dccopy=ccopy_64 -Dzcopy=zcopy_64  -Dcgemv=cgemv_64 -Dzgemv=zgemv_64  -Dcgeqr2=cgeqr2_64 -Dzgeqr2=zgeqr2_64  -Dclacpy=clacpy_64 -Dzlacpy=zlacpy_64  -Dclahqr=clahqr_64 -Dzlahqr=zlahqr_64  -Dclanhs=clanhs_64 -Dzlanhs=zlanhs_64  -Dclarnv=clarnv_64 -Dzlarnv=zlarnv_64  -Dclartg=clartg_64 -Dzlartg=zlartg_64  -Dclascl=clascl_64 -Dzlascl=zlascl_64  -Dclaset=claset_64 -Dzlaset=zlaset_64  -Dcscal=cscal_64 -Dzscal=zscal_64  -Dctrevc=ctrevc_64 -Dztrevc=ztrevc_64  -Dctrmm=ctrmm_64 -Dztrmm=ztrmm_64  -Dctrsen=ctrsen_64 -Dztrsen=ztrsen_64  -Dcgbmv=cgbmv_64 -Dzgbmv=zgbmv_64  -Dcgbtrf=cgbtrf_64 -Dzgbtrf=zgbtrf_64  -Dcgbtrs=cgbtrs_64 -Dzgbtrs=zgbtrs_64  -Dcgttrf=cgttrf_64 -Dzgttrf=zgttrf_64  -Dcgttrs=cgttrs_64 -Dzgttrs=zgttrs_64  -Dcpttrf=cpttrf_64 -Dzpttrf=zpttrf_64  -Dcpttrs=cpttrs_64 -Dzpttrs=zpttrs_64  -Dcdotc=cdotc_64 -Dzdotc=zdotc_64  -Dcgeru=cgeru_64 -Dzgeru=zgeru_64  -Dcunm2r=cunm2r_64 -Dzunm2r=zunm2r_64  -DSCOPY=SCOPY_64 -DDCOPY=DCOPY_64  -DSLABAD=SLABAD_64 -DDLABAD=DLABAD_64  -DSLAMCH=SLAMCH_64 -DDLAMCH=DLAMCH_64  -DSLANHS=SLANHS_64 -DDLANHS=DLANHS_64  -DSLANV2=SLANV2_64 -DDLANV2=DLANV2_64  -DSLARFG=SLARFG_64 -DDLARFG=DLARFG_64  -DSROT=SROT_64 -DDROT=DROT_64  -DSGEMV=SGEMV_64 -DDGEMV=DGEMV_64 -Dscnrm2=scnrm2_64 -Ddznrm2=dznrm2_64 -Dcsscal=csscal_64 -Dzdscal=zdscal_64"

else

     cmake ../arpack-ng -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_SHARED_LIBS=ON -DBLAS_LIBRARIES="-L$prefix/lib -lopenblas" -DLAPACK_LIBRARIES="-L$prefix/lib -lopenblas" -DCMAKE_Fortran_FLAGS="-O2 -fPIC -ffixed-line-length-none -cpp"

fi

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
#    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libarpack", :Arpack)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/OpenBLASBuilder/releases/download/v0.2.20-6/build.jl"         
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "ArpackBuilder", sources, script, platforms, products, dependencies)

