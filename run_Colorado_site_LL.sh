#! /bin/bash
module load python/3.10

export RES=ELM_USRDAT
export COMPSET=IELMBC
export COMPILER=gnu
export MACH=pm-cpu
export CASE_NAME=SB_Colorado2

export domainPath=/global/u1/l/locluong/data/

export domainFile=domain_BP_Colorado_0125_c250605.nc
export surfdataFile=surfdata_BP_Colorado_0125_c250605.nc

export output_dir=/global/u1/l/locluong/results/
export case_dir=/$output_dir/$CASE_NAME
export case_scripts_dir=/$case_dir/case_scripts

if [ -d "$case_dir" ]; then
# Take action if $DIR exists. #
echo "Delete the old folder"
rm -rf $case_dir
fi

cd /global/homes/l/locluong//E3SM/cime/scripts/
./create_newcase --compset ${COMPSET} --res ${RES} --case ${CASE_NAME} --script-root $case_scripts_dir --output-root ${output_dir} --compiler ${COMPILER} --mach ${MACH} --project m4986   
cd ${case_scripts_dir}

./xmlchange LND_DOMAIN_FILE=${domainFile} 
./xmlchange ATM_DOMAIN_FILE=${domainFile} 
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}


./xmlchange NTASKS=1,STOP_N=2,STOP_OPTION=nyears,JOB_WALLCLOCK_TIME="01:30:00",RUN_STARTDATE="2005-01-01",REST_N=1,REST_OPTION=nyears
./xmlchange DATM_MODE="CLMGSWP3v1",DATM_CLMNCEP_YR_START='2000',DATM_CLMNCEP_YR_END='2010'

cat >> user_nl_elm << EOF
fsurdat = '${domainPath}${surfdataFile}'
hist_mfilt = 1
hist_nhtfrq = -24
use_snicar_ad               = .true.
EOF

./case.setup 
./case.build 
echo Build_SUCCESS!
./case.submit
