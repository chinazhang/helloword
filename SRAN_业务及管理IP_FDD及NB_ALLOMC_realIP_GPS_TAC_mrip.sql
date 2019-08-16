SELECT
--*
a.MRBTS_ID
,a.cip mplanip
,b.uip Uplanip
,a.co_name BTSNAME
,FDD.enb_id FDD_enbid
,FDD.FDDenbname FDDNAME
,FDD.bts_op_state FDDSTATE
,FDD.celltac FDDTAC
,NB.enb_id NB_enbid
,NB.NBenbname NBname
,NB.bts_op_state NBSTATE
,SW.ACTIVESWRELEASEVERSION swversion
,oamaddres.oamip oamplace
,MRSERVICE.mrip MRIPadd
,FDD.mrswitch FDDMRSWITCH
,GPS.GPSTYPE
,GPS.GPSPAM
FROM
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE MRBTS_ID
,IPR.IPADD2288_1R69583LIAA cip
,MRBTS.CO_NAME
from
c_srt_ipadd_2288@OMC6 IPR
inner join ctp_common_objects@OMC6 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '2') a 
left join
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE SBTS_ID
,IPR.IPADD2288_1R69583LIAA uip
from
c_srt_ipadd_2288@OMC6 IPR
inner join ctp_common_objects@OMC6 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '1') b
on
a.MRBTS_ID = b.SBTS_ID
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name FDDenbname,
lnbts.LNBTS_ACT_CELL_TRACE mrswitch
,lncel.lncel_tac celltac
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"
--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC6 LnCEL,
c_lte_lnbts@Omc6 lnbts,
CTP_COMMON_OBJECTS@OMC6 mrb,
CTP_COMMON_OBJECTS@OMC6 bts,
CTP_COMMON_OBJECTS@OMC6 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='0'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46,lncel.lncel_tac,lnbts.LNBTS_ACT_CELL_TRACE) FDD
on
a.mrbts_id = FDD.mrbts_id
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name NBenbname
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"

--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC6 LnCEL,
c_lte_lnbts@Omc6 lnbts,
CTP_COMMON_OBJECTS@OMC6 mrb,
CTP_COMMON_OBJECTS@OMC6 bts,
CTP_COMMON_OBJECTS@OMC6 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='3'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46) NB
on
a.mrbts_id = NB.mrbts_id
left join
(SELECT 
CTP2.CO_OBJECT_INSTANCE   SBTSID,
--SRM.MNL_R_1R33793AGRV     activeGSMRATSWVersion,
--SRM.MNL_R_AC_LTERATSW_VER activeLTERATSWVersion,
SRM.MNL_R_AC_SW_REL_VER   activeSWReleaseVersion
 FROM
C_SRM_MNL_R@OMC6 SRM,
CTP_COMMON_OBJECTS@OMC6 CTP,
CTP_COMMON_OBJECTS@OMC6 CTP1,
CTP_COMMON_OBJECTS@OMC6 CTP2
WHERE
SRM.CONF_ID=1
AND SRM.OBJ_GID=CTP.CO_GID
AND CTP1.CO_GID=CTP.CO_PARENT_GID
AND CTP2.CO_GID=CTP1.CO_PARENT_GID ) SW
on
a.mrbts_id = SW.SBTSID
left join
(select
--*
mrbts.co_object_instance mrbtsid
,mp.mplanenw_5r37769opia oamip
from
c_srm_mplanenw@Omc6 mp
,ctp_common_objects@Omc6 o
,ctp_common_objects@Omc6 oo
,ctp_common_objects@Omc6 ooo
,ctp_common_objects@Omc6 mrbts
where
mp.conf_id = 1
and mp.obj_gid = o.co_gid
and o.co_parent_gid = oo.co_gid
and oo.co_parent_gid = ooo.co_gid
and ooo.co_parent_gid = mrbts.co_gid ) oamaddres
on
a.mrbts_id = oamaddres.mrbtsid
LEFT JOIN
(select
--*
MRBTS.CO_OBJECT_INSTANCE MRBTSID
,GPSR.GNSSE_R_GNSS_UNIT_NAME GPSTYPE
,GPSR.GNSSE_R_CNF_DN GPSPAM
from
c_srer_gnsse_r@Omc6 GPSR INNER JOIN CTP_COMMON_OBJECTS@OMC6 O ON GPSR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OOO ON OO.CO_PARENT_GID = OOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OOOO ON OOO.CO_PARENT_GID = OOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 OOOOO ON OOOO.CO_PARENT_GID = OOOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 MRBTS ON OOOOO.CO_PARENT_GID = MRBTS.CO_GID
WHERE GPSR.CONF_ID = 1) GPS
ON a.mrbts_id = GPS.MRBTSID
left join
(select
mrbts.co_object_instance mrbtsid
,mr.mtrace_tce_ip_address mrip
from
c_lte_mtrace@omc6 mr inner join ctp_common_objects@omc6 o on mr.obj_gid = o.co_gid 
inner join ctp_common_objects@omc6 oo on o.co_parent_gid = oo.co_gid
inner join ctp_common_objects@omc6 lnbts on oo.co_parent_gid = lnbts.co_gid
inner join ctp_common_objects@omc6 mrbts on lnbts.co_parent_gid = mrbts.co_gid
where
mr.conf_id = 1 ) MRSERVICE
ON a.mrbts_id = MRSERVICE.mrbtsid
--where
--a.MRBTS_ID in '105355'
--FDD.enb_id in ''

UNION

SELECT
--*
a.MRBTS_ID
,a.cip mplanip
,b.uip Uplanip
,a.co_name BTSNAME
,FDD.enb_id FDD_enbid
,FDD.FDDenbname FDDNAME
,FDD.bts_op_state FDDSTATE
,FDD.celltac FDDTAC
,NB.enb_id NB_enbid
,NB.NBenbname NBname
,NB.bts_op_state NBSTATE
,SW.ACTIVESWRELEASEVERSION swversion
,oamaddres.oamip oamplace
,MRSERVICE.mrip MRIPadd
,FDD.mrswitch FDDMRSWITCH
,GPS.GPSTYPE
,GPS.GPSPAM
FROM
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE MRBTS_ID
,IPR.IPADD2288_1R69583LIAA cip
,MRBTS.CO_NAME
from
c_srt_ipadd_2288@OMC7 IPR
inner join ctp_common_objects@OMC7 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '2') a 
left join
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE SBTS_ID
,IPR.IPADD2288_1R69583LIAA uip
from
c_srt_ipadd_2288@OMC7 IPR
inner join ctp_common_objects@OMC7 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '1') b
on
a.MRBTS_ID = b.SBTS_ID
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name FDDenbname
,lnbts.LNBTS_ACT_CELL_TRACE mrswitch
,lncel.lncel_tac celltac
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"
--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC7 LnCEL,
c_lte_lnbts@OMC7 lnbts,
CTP_COMMON_OBJECTS@OMC7 mrb,
CTP_COMMON_OBJECTS@OMC7 bts,
CTP_COMMON_OBJECTS@OMC7 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='0'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46,lncel.lncel_tac,lnbts.LNBTS_ACT_CELL_TRACE) FDD
on
a.mrbts_id = FDD.mrbts_id
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name NBenbname
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"

--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC7 LnCEL,
c_lte_lnbts@OMC7 lnbts,
CTP_COMMON_OBJECTS@OMC7 mrb,
CTP_COMMON_OBJECTS@OMC7 bts,
CTP_COMMON_OBJECTS@OMC7 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='3'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46) NB
on
a.mrbts_id = NB.mrbts_id
left join
(SELECT 
CTP2.CO_OBJECT_INSTANCE   SBTSID,
--SRM.MNL_R_1R33793AGRV     activeGSMRATSWVersion,
--SRM.MNL_R_AC_LTERATSW_VER activeLTERATSWVersion,
SRM.MNL_R_AC_SW_REL_VER   activeSWReleaseVersion
 FROM
C_SRM_MNL_R@OMC7 SRM,
CTP_COMMON_OBJECTS@OMC7 CTP,
CTP_COMMON_OBJECTS@OMC7 CTP1,
CTP_COMMON_OBJECTS@OMC7 CTP2
WHERE
SRM.CONF_ID=1
AND SRM.OBJ_GID=CTP.CO_GID
AND CTP1.CO_GID=CTP.CO_PARENT_GID
AND CTP2.CO_GID=CTP1.CO_PARENT_GID ) SW
on
a.mrbts_id = SW.SBTSID
left join
(select
--*
mrbts.co_object_instance mrbtsid
,mp.mplanenw_5r37769opia oamip
from
c_srm_mplanenw@OMC7 mp
,ctp_common_objects@OMC7 o
,ctp_common_objects@OMC7 oo
,ctp_common_objects@OMC7 ooo
,ctp_common_objects@OMC7 mrbts
where
mp.conf_id = 1
and mp.obj_gid = o.co_gid
and o.co_parent_gid = oo.co_gid
and oo.co_parent_gid = ooo.co_gid
and ooo.co_parent_gid = mrbts.co_gid ) oamaddres
on
a.mrbts_id = oamaddres.mrbtsid
LEFT JOIN
(select
--*
MRBTS.CO_OBJECT_INSTANCE MRBTSID
,GPSR.GNSSE_R_GNSS_UNIT_NAME GPSTYPE
,GPSR.GNSSE_R_CNF_DN GPSPAM
from
c_srer_gnsse_r@OMC7 GPSR INNER JOIN CTP_COMMON_OBJECTS@OMC7 O ON GPSR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OOO ON OO.CO_PARENT_GID = OOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OOOO ON OOO.CO_PARENT_GID = OOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 OOOOO ON OOOO.CO_PARENT_GID = OOOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 MRBTS ON OOOOO.CO_PARENT_GID = MRBTS.CO_GID
WHERE GPSR.CONF_ID = 1 ) GPS
ON a.mrbts_id = GPS.MRBTSID
left join
(select
mrbts.co_object_instance mrbtsid
,mr.mtrace_tce_ip_address mrip
from
c_lte_mtrace@OMC7 mr inner join ctp_common_objects@OMC7 o on mr.obj_gid = o.co_gid 
inner join ctp_common_objects@OMC7 oo on o.co_parent_gid = oo.co_gid
inner join ctp_common_objects@OMC7 lnbts on oo.co_parent_gid = lnbts.co_gid
inner join ctp_common_objects@OMC7 mrbts on lnbts.co_parent_gid = mrbts.co_gid
where
mr.conf_id = 1 ) MRSERVICE
ON a.mrbts_id = MRSERVICE.mrbtsid
--where
--a.MRBTS_ID in '105355'
--FDD.enb_id in ''

UNION

SELECT
--*
a.MRBTS_ID
,a.cip mplanip
,b.uip Uplanip
,a.co_name BTSNAME
,FDD.enb_id FDD_enbid
,FDD.FDDenbname FDDNAME
,FDD.bts_op_state FDDSTATE
,FDD.celltac FDDTAC
,NB.enb_id NB_enbid
,NB.NBenbname NBname
,NB.bts_op_state NBSTATE
,SW.ACTIVESWRELEASEVERSION swversion
,oamaddres.oamip oamplace
,MRSERVICE.mrip MRIPadd
,FDD.mrswitch FDDMRSWITCH
,GPS.GPSTYPE
,GPS.GPSPAM
FROM
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE MRBTS_ID
,IPR.IPADD2288_1R69583LIAA cip
,MRBTS.CO_NAME
from
c_srt_ipadd_2288@OMC9 IPR
inner join ctp_common_objects@OMC9 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '2') a 
left join
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE SBTS_ID
,IPR.IPADD2288_1R69583LIAA uip
from
c_srt_ipadd_2288@OMC9 IPR
inner join ctp_common_objects@OMC9 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '1') b
on
a.MRBTS_ID = b.SBTS_ID
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name FDDenbname
,lnbts.LNBTS_ACT_CELL_TRACE mrswitch
,lncel.lncel_tac celltac
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"
--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC9 LnCEL,
c_lte_lnbts@OMC9 lnbts,
CTP_COMMON_OBJECTS@OMC9 mrb,
CTP_COMMON_OBJECTS@OMC9 bts,
CTP_COMMON_OBJECTS@OMC9 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='0'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46,lncel.lncel_tac,lnbts.LNBTS_ACT_CELL_TRACE) FDD
on
a.mrbts_id = FDD.mrbts_id
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name NBenbname
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"

--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC9 LnCEL,
c_lte_lnbts@OMC9 lnbts,
CTP_COMMON_OBJECTS@OMC9 mrb,
CTP_COMMON_OBJECTS@OMC9 bts,
CTP_COMMON_OBJECTS@OMC9 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='3'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46) NB
on
a.mrbts_id = NB.mrbts_id
left join
(SELECT 
CTP2.CO_OBJECT_INSTANCE   SBTSID,
--SRM.MNL_R_1R33793AGRV     activeGSMRATSWVersion,
--SRM.MNL_R_AC_LTERATSW_VER activeLTERATSWVersion,
SRM.MNL_R_AC_SW_REL_VER   activeSWReleaseVersion
 FROM
C_SRM_MNL_R@OMC9 SRM,
CTP_COMMON_OBJECTS@OMC9 CTP,
CTP_COMMON_OBJECTS@OMC9 CTP1,
CTP_COMMON_OBJECTS@OMC9 CTP2
WHERE
SRM.CONF_ID=1
AND SRM.OBJ_GID=CTP.CO_GID
AND CTP1.CO_GID=CTP.CO_PARENT_GID
AND CTP2.CO_GID=CTP1.CO_PARENT_GID ) SW
on
a.mrbts_id = SW.SBTSID
left join
(select
--*
mrbts.co_object_instance mrbtsid
,mp.mplanenw_5r37769opia oamip
from
c_srm_mplanenw@OMC9 mp
,ctp_common_objects@OMC9 o
,ctp_common_objects@OMC9 oo
,ctp_common_objects@OMC9 ooo
,ctp_common_objects@OMC9 mrbts
where
mp.conf_id = 1
and mp.obj_gid = o.co_gid
and o.co_parent_gid = oo.co_gid
and oo.co_parent_gid = ooo.co_gid
and ooo.co_parent_gid = mrbts.co_gid ) oamaddres
on
a.mrbts_id = oamaddres.mrbtsid
LEFT JOIN
(select
--*
MRBTS.CO_OBJECT_INSTANCE MRBTSID
,GPSR.GNSSE_R_GNSS_UNIT_NAME GPSTYPE
,GPSR.GNSSE_R_CNF_DN GPSPAM
from
c_srer_gnsse_r@OMC9 GPSR INNER JOIN CTP_COMMON_OBJECTS@OMC9 O ON GPSR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OOO ON OO.CO_PARENT_GID = OOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OOOO ON OOO.CO_PARENT_GID = OOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 OOOOO ON OOOO.CO_PARENT_GID = OOOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 MRBTS ON OOOOO.CO_PARENT_GID = MRBTS.CO_GID
WHERE GPSR.CONF_ID = 1 ) GPS
ON a.mrbts_id = GPS.MRBTSID
left join
(select
mrbts.co_object_instance mrbtsid
,mr.mtrace_tce_ip_address mrip
from
c_lte_mtrace@OMC9 mr inner join ctp_common_objects@OMC9 o on mr.obj_gid = o.co_gid 
inner join ctp_common_objects@OMC9 oo on o.co_parent_gid = oo.co_gid
inner join ctp_common_objects@OMC9 lnbts on oo.co_parent_gid = lnbts.co_gid
inner join ctp_common_objects@OMC9 mrbts on lnbts.co_parent_gid = mrbts.co_gid
where
mr.conf_id = 1 ) MRSERVICE
ON a.mrbts_id = MRSERVICE.mrbtsid
--where
--a.MRBTS_ID in '105355'
--FDD.enb_id in ''

UNION

SELECT
--*
a.MRBTS_ID
,a.cip mplanip
,b.uip Uplanip
,a.co_name BTSNAME
,FDD.enb_id FDD_enbid
,FDD.FDDenbname FDDNAME
,FDD.bts_op_state FDDSTATE
,FDD.celltac FDDTAC
,NB.enb_id NB_enbid
,NB.NBenbname NBname
,NB.bts_op_state NBSTATE
,SW.ACTIVESWRELEASEVERSION swversion
,oamaddres.oamip oamplace
,MRSERVICE.mrip MRIPadd
,FDD.mrswitch FDDMRSWITCH
,GPS.GPSTYPE
,GPS.GPSPAM
FROM
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE MRBTS_ID
,IPR.IPADD2288_1R69583LIAA cip
,MRBTS.CO_NAME
from
c_srt_ipadd_2288@OMC3 IPR
inner join ctp_common_objects@OMC3 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '2') a 
left join
(select
DISTINCT
--*
MRBTS.CO_OBJECT_INSTANCE SBTS_ID
,IPR.IPADD2288_1R69583LIAA uip
from
c_srt_ipadd_2288@OMC3 IPR
inner join ctp_common_objects@OMC3 O on IPR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 IPIF ON OO.CO_PARENT_GID = IPIF.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 IPNO ON IPIF.CO_PARENT_GID = IPNO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 TNL ON IPNO.CO_PARENT_GID = TNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 TNLS ON TNL.CO_PARENT_GID = TNLS.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 MRBTS ON TNLS.CO_PARENT_GID = MRBTS.CO_GID
where
IPR.Conf_Id = 1
AND IPIF.CO_OBJECT_INSTANCE = '1') b
on
a.MRBTS_ID = b.SBTS_ID
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name FDDenbname
,lnbts.LNBTS_ACT_CELL_TRACE mrswitch
,lncel.lncel_tac celltac
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"
--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC3 LnCEL,
c_lte_lnbts@OMC3 lnbts,
CTP_COMMON_OBJECTS@OMC3 mrb,
CTP_COMMON_OBJECTS@OMC3 bts,
CTP_COMMON_OBJECTS@OMC3 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='0'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46,lncel.lncel_tac,lnbts.LNBTS_ACT_CELL_TRACE) FDD
on
a.mrbts_id = FDD.mrbts_id
left join
(SELECT 
--DISTINCT
--*
--DECODE(LNCEL_CLL_TECHNOLOGY,0,'FDD',1,'TDD',3,'NB') cellTechnology,
mrb.CO_OBJECT_INSTANCE MRBTS_ID,
bts.CO_OBJECT_INSTANCE  ENB_ID,
lnbts.lnbts_enb_name NBenbname
--lncel_cell_name cellname,
--cel.co_object_instance cellid
--,Decode(bts.CO_STATE,0,'Operational',2,'Created from the network',3,'Non-operational',9,'To be deleted',bts.CO_STATE) lnbts_co_state
,DECODE(lnbts.lnbts_os_46,0,'INITIALIZING',1,'COMMISSIONED',2,'NOTCOMMISIONED',3,'CONFIGURED',4,'INTEGRATED TO RAN',5,'ONAIR',6,'TEST',lnbts.lnbts_os_46) bts_op_state
--,DECODE(lncel.lncel_os_132,0,'DISABLE',1,'ENABLE',lncel.lncel_os_132) CELL_op_state
--,DECODE(lncel.LNCEL_AS_26,1,'unlocked',2,'shutting down',3,'locked')  "administrativeState"

--,bts.co_sys_version
FROM
C_LTE_LNCEL@OMC3 LnCEL,
c_lte_lnbts@OMC3 lnbts,
CTP_COMMON_OBJECTS@OMC3 mrb,
CTP_COMMON_OBJECTS@OMC3 bts,
CTP_COMMON_OBJECTS@OMC3 cel
where
LnCEL.CONF_ID=1
AND LnCEL.OBJ_GID=cel.CO_GID
AND lnbts.obj_gid=bts.co_gid
and mrb.co_gid=bts.co_parent_gid
and bts.co_gid=cel.co_parent_gid
and lnbts.conf_id=1
and LnCEL.LNCEL_CLL_TECHNOLOGY='3'

group by
mrb.CO_OBJECT_INSTANCE,bts.CO_OBJECT_INSTANCE,lnbts.lnbts_enb_name,lnbts.lnbts_os_46) NB
on
a.mrbts_id = NB.mrbts_id
left join
(SELECT 
CTP2.CO_OBJECT_INSTANCE   SBTSID,
--SRM.MNL_R_1R33793AGRV     activeGSMRATSWVersion,
--SRM.MNL_R_AC_LTERATSW_VER activeLTERATSWVersion,
SRM.MNL_R_AC_SW_REL_VER   activeSWReleaseVersion
 FROM
C_SRM_MNL_R@OMC3 SRM,
CTP_COMMON_OBJECTS@OMC3 CTP,
CTP_COMMON_OBJECTS@OMC3 CTP1,
CTP_COMMON_OBJECTS@OMC3 CTP2
WHERE
SRM.CONF_ID=1
AND SRM.OBJ_GID=CTP.CO_GID
AND CTP1.CO_GID=CTP.CO_PARENT_GID
AND CTP2.CO_GID=CTP1.CO_PARENT_GID ) SW
on
a.mrbts_id = SW.SBTSID
left join
(select
--*
mrbts.co_object_instance mrbtsid
,mp.mplanenw_5r37769opia oamip
from
c_srm_mplanenw@OMC3 mp
,ctp_common_objects@OMC3 o
,ctp_common_objects@OMC3 oo
,ctp_common_objects@OMC3 ooo
,ctp_common_objects@OMC3 mrbts
where
mp.conf_id = 1
and mp.obj_gid = o.co_gid
and o.co_parent_gid = oo.co_gid
and oo.co_parent_gid = ooo.co_gid
and ooo.co_parent_gid = mrbts.co_gid ) oamaddres
on
a.mrbts_id = oamaddres.mrbtsid
LEFT JOIN
(select
--*
MRBTS.CO_OBJECT_INSTANCE MRBTSID
,GPSR.GNSSE_R_GNSS_UNIT_NAME GPSTYPE
,GPSR.GNSSE_R_CNF_DN GPSPAM
from
c_srer_gnsse_r@OMC3 GPSR INNER JOIN CTP_COMMON_OBJECTS@OMC3 O ON GPSR.OBJ_GID = O.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OO ON O.CO_PARENT_GID = OO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OOO ON OO.CO_PARENT_GID = OOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OOOO ON OOO.CO_PARENT_GID = OOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 OOOOO ON OOOO.CO_PARENT_GID = OOOOO.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC3 MRBTS ON OOOOO.CO_PARENT_GID = MRBTS.CO_GID
WHERE GPSR.CONF_ID = 1) GPS
ON a.mrbts_id = GPS.MRBTSID
left join
(select
mrbts.co_object_instance mrbtsid
,mr.mtrace_tce_ip_address mrip
from
c_lte_mtrace@OMC3 mr inner join ctp_common_objects@OMC3 o on mr.obj_gid = o.co_gid 
inner join ctp_common_objects@OMC3 oo on o.co_parent_gid = oo.co_gid
inner join ctp_common_objects@OMC3 lnbts on oo.co_parent_gid = lnbts.co_gid
inner join ctp_common_objects@OMC3 mrbts on lnbts.co_parent_gid = mrbts.co_gid
where
mr.conf_id = 1 ) MRSERVICE
ON a.mrbts_id = MRSERVICE.mrbtsid
--where
--a.MRBTS_ID in '105355'
--FDD.enb_id in ''