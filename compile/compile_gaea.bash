#!/bin/bash
gaea_dev=/lustre/f2/dev/gfdl/Liz.Drenkard
MOM6_ex=$gaea_dev/MOM6-examples
MKMF_DIR=$MOM6_ex/src/mkmf
ICEPACK=$gaea_dev/Icepack
FMS=$MOM6_ex/src/FMS1
MOM6=$MOM6_ex/src/MOM6
COUPLER=$MOM6_ex/src/coupler
ATMOS_NULL=$MOM6_ex/src/atmos_null
LAND_NULL=$MOM6_ex/src/land_null
ICE_PARAM=$MOM6_ex/src/ice_param
ICEBERGS=$MOM6_ex/src/icebergs
SIS2=$MOM6_ex/src/SIS2

compile_fms=1
compile_mom=1
compile_ice=1

module unload PrgEnv-pathscale
module unload PrgEnv-pgi
module unload PrgEnv-intel
module unload PrgEnv-gnu
module unload PrgEnv-cray

module load PrgEnv-intel
module swap intel intel/19.0.5.281
module unload netcdf
module load cray-netcdf
module load cray-hdf5

module unload darshan

cd $MOM6_ex

if [ $compile_fms == 1 ] ; then
    rm -rf build/intel/shared/repro/
    mkdir -p build/intel/shared/repro/
    cd build/intel/shared/repro/
    rm -f path_names

    $MKMF_DIR/bin/list_paths $FMS
    $MKMF_DIR/bin/mkmf -t  $MKMF_DIR/templates/ncrc-intel.mk -p libfms.a -c "-Duse_libMPI -Duse_netCDF -DSPMD" path_names
    make NETCDF=3 REPRO=1 libfms.a -j 4
fi


if [ $compile_ice == 1 ] ; then
    rm -f path_names

    $MKMF_DIR/bin/list_paths -l $ICEPACK/columnphysics
    $MKMF_DIR/bin/mkmf -t $MKMF_DIR/templates/ncrc-intel.mk -p libIcepack.a -c '-Duse_libMPI -Duse_netCDF -DSPMD' path_names
    make NETCDF=3 REPRO=1 libIcepack.a -j 4
fi


SYM_SIS2_PTH="$MOM6/config_src/{infra/FMS1,memory/dynamic_symmetric,drivers/FMS_cap,external} $MOM6/src/{*,*/*}/ $COUPLER $ATMOS_NULL $LAND_NULL $ICE_PARAM $ICEPACK/columnphysics $ICEBERGS $SIS2/src/ $SIS2/config_src/dynamic_symmetric $FMS/{coupler,include}"


cd $MOM6_ex

if [ $compile_mom == 1 ] ; then

    rm -rf build/intel/ice_ocean_SIS2/repro/
    mkdir -p build/intel/ice_ocean_SIS2/repro/
    cd build/intel/ice_ocean_SIS2/repro/
    rm -f path_names

    $MKMF_DIR/bin/list_paths -l $SYM_SIS2_PTH
    $MKMF_DIR/bin/mkmf -t $MKMF_DIR/templates/ncrc-intel.mk -o '-I../../shared/repro' -p MOM6 -l '-L../../shared/repro -lfms -lIcepack' -c '-Duse_libMPI -Duse_netCDF -DSPMD -DUSE_LOG_DIAG_FIELD_INFO -D_USE_LEGACY_LAND_ -Duse_AM3_physics' path_names
    make NETCDF=3 REPRO=1 MOM6 -j 4
fi

