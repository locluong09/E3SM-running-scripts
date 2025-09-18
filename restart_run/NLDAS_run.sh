
export domainPath=/compyfs/haod776/e3sm_scratch/surfdata/
export domainFile=domain_WUS_0125_c220106.nc
export surfdataFile=surfdata_with_top_WUS_0125_c220106.nc

# TOP
export RES=ELM_USRDAT
export COMPSET=IELMBC 
export COMPILER=intel 
export MACH=compy 
export CASE_NAME=evaluation_WUS_TOP_N_3000
export initPath=/compyfs/haod776/e3sm_scratch/spinup_WUS_TOP/run/
export initFile=spinup_WUS_TOP.elm.r.2000-01-01-00000.nc

cd /qfs/people/haod776/E3SMv2_0/cime/scripts 
./create_newcase -compset ${COMPSET} -res ${RES} -case ${CASE_NAME} -compiler ${COMPILER} -mach ${MACH} -project ESMD  
cd ${CASE_NAME}

./xmlchange LND_DOMAIN_FILE=${domainFile} 
./xmlchange ATM_DOMAIN_FILE=${domainFile} 
./xmlchange LND_DOMAIN_PATH=${domainPath}
./xmlchange ATM_DOMAIN_PATH=${domainPath}
./xmlchange NTASKS=1024,STOP_N=5,STOP_OPTION=nyears,JOB_WALLCLOCK_TIME="20:00:00",RUN_STARTDATE="2000-01-01",REST_N=1,REST_OPTION=nyears,RESUBMIT=4
./xmlchange DATM_MODE=CLMMOSARTTEST,DATM_CLMNCEP_YR_START='1979',DATM_CLMNCEP_YR_END='2020'

cat >> user_nl_elm << EOF
fsurdat = '${domainPath}${surfdataFile}'
use_top_solar_rad           = .true.

hist_empty_htapes           = .true.
hist_fincl1                 ='ALBD','ALBI','FSA','FSDS','FIRE','FSNO','SNOWDP','H2OSNO','DSTDEP','SNORDSL','ALBSND','ALBSND_PUR','ALBSND_NODUST','ALBSND_NOBC','ALBSNI','ALBSNI_PUR','ALBSNI_NODUST','ALBSNI_NOBC','FSDSND','FSDSNI','FSDSVD','FSDSVI'
hist_fincl2                 ='ALBD','ALBI','ALB','ALBSN','ALBSN_PUR','ALBSN_NODUST','ALBSN_NOBC','FSA','FSR','FSDS','FIRA','FLDS','FIRE','FGR','FSH','EFLX_LH_TOT','QSNOMELT','QRUNOFF','QOVER','FSNO','SNOWDP','H2OSNO','SNORDSL','SNOAERFRC2L','SNOAERFRCL','SNOBCFRC2L','SNOBCFRCL','SNODSTFRC2L','SNODSTFRCL','SNOBCMCL','SNOBCMSL','SNODSTMCL','SNODSTMSL','TSOI_10CM','BCDEP','DSTDEP','ALBSND','ALBSND_PUR','ALBSND_NODUST','ALBSND_NOBC','ALBSNI','ALBSNI_PUR','ALBSNI_NODUST','ALBSNI_NOBC','FSDSND','FSDSNI','FSDSVD','FSDSVI','mss_cnc_bcphi_col','mss_cnc_bcpho_col','mss_cnc_dst1_col','mss_cnc_dst2_col','mss_cnc_dst3_col','mss_cnc_dst4_col'
hist_fincl3                 ='ALBD','ALBI','ALB','ALBSN','ALBSN_PUR','ALBSN_NODUST','ALBSN_NOBC','FSA','FSR','FSDS','FIRA','FLDS','FIRE','FGR','FSH','EFLX_LH_TOT','QSNOMELT','QRUNOFF','QOVER','FSNO','SNOWDP','H2OSNO','SNORDSL','SNOAERFRC2L','SNOAERFRCL','SNOBCFRC2L','SNOBCFRCL','SNODSTFRC2L','SNODSTFRCL','SNOBCMCL','SNOBCMSL','SNODSTMCL','SNODSTMSL','TSOI_10CM','BCDEP','DSTDEP','ALBSND','ALBSND_PUR','ALBSND_NODUST','ALBSND_NOBC','ALBSNI','ALBSNI_PUR','ALBSNI_NODUST','ALBSNI_NOBC','FSDSND','FSDSNI','FSDSVD','FSDSVI','mss_cnc_bcphi_col','mss_cnc_bcpho_col','mss_cnc_dst1_col','mss_cnc_dst2_col','mss_cnc_dst3_col','mss_cnc_dst4_col'
hist_nhtfrq                 = 1,-24,0
hist_mfilt                  = 48,365,12

snow_shape_defined          = 1
use_snicar_ad               = .true.
use_snicar_frc              = .true.
is_dust_internal_mixing		= .false.
is_BC_internal_mixing		= .true.
snicar_atm_type				= 1
fsnowoptics = '${domainPath}snicar_optics_5bnd_mam_c211006.nc'
finidat = '${initPath}${initFile}'
EOF

./case.setup 
./case.build 
./case.submit