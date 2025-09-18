
export domainPath=/compyfs/haod776/e3sm_scratch/surfdata/
export domainFile=domain_WUS_0125_c220106.nc
export surfdataFile=surfdata_with_top_WUS_0125_c220106.nc

# RESTART FILE PATH
export initPath=/compyfs/haod776/e3sm_scratch/spinup_WUS_TOP/run/
export initFile=spinup_WUS_TOP.elm.r.2000-01-01-00000.nc

# TOP
export RES=ELM_USRDAT
export COMPSET=IELMBC 
export COMPILER=intel 
export MACH=compy 
export CASE_NAME=spinup_WUS_TOP

cd /qfs/people/haod776/E3SMv2_0/cime/scripts 
./create_newcase -compset ${COMPSET} -res ${RES} -case ${CASE_NAME} -compiler ${COMPILER} -mach ${MACH} -project ESMD  
cd ${CASE_NAME}

./xmlchange LND_DOMAIN_FILE=${domainFile} 
./xmlchange ATM_DOMAIN_FILE=${domainFile} 
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}
./xmlchange NTASKS=512,STOP_N=5,STOP_OPTION=nyears,JOB_WALLCLOCK_TIME="10:00:00",RUN_STARTDATE="1979-01-01",REST_N=1,REST_OPTION=nyears,RESUBMIT=4
./xmlchange DATM_MODE=CLMMOSARTTEST,DATM_CLMNCEP_YR_START='1979',DATM_CLMNCEP_YR_END='2020'

cat >> user_nl_elm << EOF
fsurdat = '${domainPath}${surfdataFile}'
finidat = '${initPath}${initFile}'
use_top_solar_rad           = .true.
hist_empty_htapes           = .true.
hist_fincl1                 = 'FSA','FSH','EFLX_LH_TOT','FSNO','SNOWDP','H2OSNO','SNORDSL'
hist_nhtfrq                 = 0
hist_mfilt                  = 12

snow_shape_defined          = 1
use_snicar_ad               = .true.
use_snicar_frc              = .true.
is_dust_internal_mixing		= .false.
is_BC_internal_mixing		= .true.
snicar_atm_type				= 1
fsnowoptics = '${domainPath}snicar_optics_5bnd_mam_c211006.nc'
EOF

./case.setup 
./case.build 
./case.submit
