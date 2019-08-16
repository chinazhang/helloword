select 
    --substr(DN,instr(DN,'-',1,2)+1,instr(DN,'/',1,2)-instr(DN,'-',1,2)-1) MRBTSID
    DN
    ,AGENT_ID
    ,severity
    ,text
    ,supplementary_info
    ,alarm_number
    ,alarm_time
    ,cancel_time
    --*
from 
    fx_alarm@OMC6
where 
--dn like '%BSC-404483/BCF-82%' 
--dn like '%BSC-403775/BCF-100%'
-- (dn like '%MRBTS-365056%'or dn like '%MRBTS-364891%')
 dn like '%MRBTS%'
 --(alarm_time between
   --   to_date('20180701 00:00:00','yyyymmdd hh24:mi:ss') and
     -- to_date('20180801 00:00:00','yyyymmdd hh24:mi:ss'))
 --supplementary_info like 'Virtual node not responding' 
 --supplementary_info like 'pipe dangerously overheating' 
 --supplementary_info like 'S1 interface setup failure' 
 --supplementary_info like 'Transport layer connection failure in S1 interface'
--and supplementary_info like 'Difference between BTS master clock and reference frequency'
/*and (supplementary_info like 'PPS reference missing' or 
supplementary_info like 'GPS Receiver alarm: control interface not available' or
supplementary_info like 'GPS receiver alarm: no stored position' or
supplementary_info like 'GPS receiver alarm: survey in progress'or
supplementary_info like 'GPS receiver alarm: not tracking satellites')*/
 --supplementary_info like 'Cell configuration data distribution failed'
--text like 'BTS WITH NO TRANSACTIONS'
--and text like 'LICENSE CAPACITY NOT AVAILABLE'
 and alarm_status ='1'
--and severity = '1'
--and alarm_number = 41004
--and ALARM_TIME > SYSDATE - 1

--ORDER BY ALARM_TIME desc

UNION

select 
    --substr(DN,instr(DN,'-',1,2)+1,instr(DN,'/',1,2)-instr(DN,'-',1,2)-1) MRBTSID
    DN
    ,AGENT_ID
    ,severity
    ,text
    ,supplementary_info
    ,alarm_number
    ,alarm_time
    ,cancel_time
    --*
from 
    fx_alarm@OMC7
where 
--dn like '%BSC-404483/BCF-82%' 
--dn like '%BSC-403775/BCF-100%'
-- (dn like '%MRBTS-365056%'or dn like '%MRBTS-364891%')
 dn like '%MRBTS%'
 --(alarm_time between
   --   to_date('20180701 00:00:00','yyyymmdd hh24:mi:ss') and
     -- to_date('20180801 00:00:00','yyyymmdd hh24:mi:ss'))
 --supplementary_info like 'Virtual node not responding' 
 --supplementary_info like 'pipe dangerously overheating' 
 --supplementary_info like 'S1 interface setup failure' 
 --supplementary_info like 'Transport layer connection failure in S1 interface'
--and supplementary_info like 'Difference between BTS master clock and reference frequency'
/*and (supplementary_info like 'PPS reference missing' or 
supplementary_info like 'GPS Receiver alarm: control interface not available' or
supplementary_info like 'GPS receiver alarm: no stored position' or
supplementary_info like 'GPS receiver alarm: survey in progress'or
supplementary_info like 'GPS receiver alarm: not tracking satellites')*/
 --supplementary_info like 'Cell configuration data distribution failed'
--text like 'BTS WITH NO TRANSACTIONS'
--and text like 'LICENSE CAPACITY NOT AVAILABLE'
 and alarm_status ='1'
--and severity = '1'
--and alarm_number = 41004
--and ALARM_TIME > SYSDATE - 1

--ORDER BY ALARM_TIME desc

UNION

select 
    --substr(DN,instr(DN,'-',1,2)+1,instr(DN,'/',1,2)-instr(DN,'-',1,2)-1) MRBTSID
    DN
    ,AGENT_ID
    ,severity
    ,text
    ,supplementary_info
    ,alarm_number
    ,alarm_time
    ,cancel_time
    --*
from 
    fx_alarm@OMC9
where 
--dn like '%BSC-404483/BCF-82%' 
--dn like '%BSC-403775/BCF-100%'
-- (dn like '%MRBTS-365056%'or dn like '%MRBTS-364891%')
 dn like '%MRBTS%'
 --(alarm_time between
   --   to_date('20180701 00:00:00','yyyymmdd hh24:mi:ss') and
     -- to_date('20180801 00:00:00','yyyymmdd hh24:mi:ss'))
 --supplementary_info like 'Virtual node not responding' 
 --supplementary_info like 'pipe dangerously overheating' 
 --supplementary_info like 'S1 interface setup failure' 
 --supplementary_info like 'Transport layer connection failure in S1 interface'
--and supplementary_info like 'Difference between BTS master clock and reference frequency'
/*and (supplementary_info like 'PPS reference missing' or 
supplementary_info like 'GPS Receiver alarm: control interface not available' or
supplementary_info like 'GPS receiver alarm: no stored position' or
supplementary_info like 'GPS receiver alarm: survey in progress'or
supplementary_info like 'GPS receiver alarm: not tracking satellites')*/
 --supplementary_info like 'Cell configuration data distribution failed'
--text like 'BTS WITH NO TRANSACTIONS'
--and text like 'LICENSE CAPACITY NOT AVAILABLE'
 and alarm_status ='1'
--and severity = '1'
--and alarm_number = 41004
--and ALARM_TIME > SYSDATE - 1

--ORDER BY ALARM_TIME desc

UNION

select 
    --substr(DN,instr(DN,'-',1,2)+1,instr(DN,'/',1,2)-instr(DN,'-',1,2)-1) MRBTSID
    DN
    ,AGENT_ID
    ,severity
    ,text
    ,supplementary_info
    ,alarm_number
    ,alarm_time
    ,cancel_time
    --*
from 
    fx_alarm@OMC3
where 
--dn like '%BSC-404483/BCF-82%' 
--dn like '%BSC-403775/BCF-100%'
-- (dn like '%MRBTS-365056%'or dn like '%MRBTS-364891%')
 dn like '%MRBTS%'
 --(alarm_time between
   --   to_date('20180701 00:00:00','yyyymmdd hh24:mi:ss') and
     -- to_date('20180801 00:00:00','yyyymmdd hh24:mi:ss'))
 --supplementary_info like 'Virtual node not responding' 
 --supplementary_info like 'pipe dangerously overheating' 
 --supplementary_info like 'S1 interface setup failure' 
 --supplementary_info like 'Transport layer connection failure in S1 interface'
--and supplementary_info like 'Difference between BTS master clock and reference frequency'
/*and (supplementary_info like 'PPS reference missing' or 
supplementary_info like 'GPS Receiver alarm: control interface not available' or
supplementary_info like 'GPS receiver alarm: no stored position' or
supplementary_info like 'GPS receiver alarm: survey in progress'or
supplementary_info like 'GPS receiver alarm: not tracking satellites')*/
 --supplementary_info like 'Cell configuration data distribution failed'
--text like 'BTS WITH NO TRANSACTIONS'
--and text like 'LICENSE CAPACITY NOT AVAILABLE'
 and alarm_status ='1'
--and severity = '1'
--and alarm_number = 41004
--and ALARM_TIME > SYSDATE - 1

--ORDER BY ALARM_TIME desc
