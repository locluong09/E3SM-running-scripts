#! /bin/bash
module load python/3.10

export RES=ELM_USRDAT 
export COMPSET=IELMBC
export COMPILER=gnu
export MACH=pm-cpu
export CASE_NAME=WUS_dynamic_shape_spinup_1979_2025

export domainPath=/global/cfs/cdirs/m4986/data/enrico_data/WUS_surface_data/
export domainFile=domain_WUS_0125_c220106.nc
export surfdataFile=surfdata_with_top_WUS_0125_c220106.nc


export output_dir=/global/cfs/cdirs/m4986/data/locluong/results/
export case_dir=/$output_dir/$CASE_NAME
export case_scripts_dir=/$case_dir/case_scripts

if [ -d "$case_dir" ]; then
# Take action if $DIR exists. #
echo "Delete the old folder"
rm -rf $case_dir
fi

cd /global/homes/l/locluong/ESM_shape/E3SM/cime/scripts/
./create_newcase --compset ${COMPSET} --res ${RES} --case ${CASE_NAME} --script-root $case_scripts_dir --output-root ${output_dir} --compiler ${COMPILER} --mach ${MACH} --project m4986   
cd ${case_scripts_dir}


./xmlchange LND_DOMAIN_FILE=${domainFile} 
./xmlchange ATM_DOMAIN_FILE=${domainFile} 
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}


./xmlchange NTASKS=2048,STOP_N=46,STOP_OPTION=nyears,JOB_WALLCLOCK_TIME="10:00:00",RUN_STARTDATE="1979-01-01",REST_N=10,REST_OPTION=nyears
./xmlchange DATM_MODE="CLMNLDAS2",DATM_CLMNCEP_YR_START='1979',DATM_CLMNCEP_YR_END='2025'

cat >> user_nl_elm << EOF
fsurdat = '${domainPath}${surfdataFile}'
hist_empty_htapes = .true.
hist_mfilt = 365, 12, 46
hist_nhtfrq = -1, 0, 0
use_snicar_ad               = .true.
use_top_solar_rad           = .false.
use_dynamic_snow_shape = .true.
hist_fincl1 = 'SNO_GS','SNO_DEN','SNO_SPH', 'FSA', 'FSDS', 'FSNO', 'H2OSNO', 'ABLD', 'ABLI', 'ALBGRD', 'ALBGRI', 'SNOW_DEPTH'
hist_fincl2 = 'SNO_GS','SNO_DEN','SNO_SPH', 'FSA', 'FSDS', 'FSNO', 'H2OSNO', 'ABLD', 'ABLI', 'ALBGRD', 'ALBGRI', 'SNOW_DEPTH'
hist_fincl3 = 'SNO_GS','SNO_DEN','SNO_SPH', 'FSA', 'FSDS', 'FSNO', 'H2OSNO', 'ABLD', 'ABLI', 'ALBGRD', 'ALBGRI', 'SNOW_DEPTH'

EOF
./case.setup 
./case.build 
./case.submit