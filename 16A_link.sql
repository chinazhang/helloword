select *

from

(select A.CO_OBJECT_INSTANCE
,SMOD.L6_LINK_ID
,SMOD.L6_LINK_SPEED
,B.CO_DN

from C_LTE_SMOD_L6_LIST SMOD
     ,ctp_common_objects a
     ,ctp_common_objects b

where SMOD.obj_gid=b.co_gid
      and a.co_gid=b.co_parent_gid
      and SMOD.conf_id='1'

union all


select A.CO_OBJECT_INSTANCE
,BBMOD.L2_LINK_ID
,BBMOD.L2_LINK_SPEED
,B.CO_DN


from C_LTE_BBMOD_L2_LIST bbmod
     ,ctp_common_objects a
     ,ctp_common_objects b

where BBMOD.obj_gid=b.co_gid
      and a.co_gid=b.co_parent_gid
      and BBMOD.conf_id='1') bbu1

left join



(select A.CO_OBJECT_INSTANCE
,SMOD.L6_LINK_ID
,SMOD.L6_LINK_SPEED
,B.CO_DN

from C_LTE_SMOD_L6_LIST SMOD
     ,ctp_common_objects a
     ,ctp_common_objects b

where SMOD.obj_gid=b.co_gid
      and a.co_gid=b.co_parent_gid
      and SMOD.conf_id='1'

union all

select A.CO_OBJECT_INSTANCE
,BBMOD.L2_LINK_ID
,BBMOD.L2_LINK_SPEED
,B.CO_DN


from C_LTE_BBMOD_L2_LIST bbmod
     ,ctp_common_objects a
     ,ctp_common_objects b

where BBMOD.obj_gid=b.co_gid
      and a.co_gid=b.co_parent_gid
      and BBMOD.conf_id='1'

union all

select A.CO_OBJECT_INSTANCE
,RMOD.C2_LINK_ID
,RMOD.C2_POS_IN_CHAIN
,B.CO_DN



from C_LTE_RMOD_C2_LIST RMOD
     ,ctp_common_objects a
     ,ctp_common_objects b

where RMOD.obj_gid=b.co_gid
      and a.co_gid=b.co_parent_gid
      and RMOD.conf_id='1') bbu2


on bbu1.CO_OBJECT_INSTANCE=bbu2.CO_OBJECT_INSTANCE
