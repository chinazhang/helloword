SELECT
--*
'OMC6' OMC
,CMRBTS.CO_NAME BTSNAME
,CMRBTS.CO_OBJECT_INSTANCE MRBTSID
,CLOCK.SI2_SYNC_INPUT_PRIO
,CLOCK.SI2_SYNC_INPUT_TYPE
FROM
C_SRM_CLOCK_SI2_@OMC6 CLOCK INNER JOIN CTP_COMMON_OBJECTS@OMC6 CCLOCK ON CLOCK.OBJ_GID = CCLOCK.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 CSYNC ON CCLOCK.CO_PARENT_GID = CSYNC.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 CMNLENT ON CSYNC.CO_PARENT_GID = CMNLENT.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 CMNL ON CMNLENT.CO_PARENT_GID = CMNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC6 CMRBTS ON CMNL.CO_PARENT_GID = CMRBTS.CO_GID
WHERE
CLOCK.CONF_ID = 1

UNION ALL

SELECT
--*
'OMC7' OMC
,CMRBTS.CO_NAME BTSNAME
,CMRBTS.CO_OBJECT_INSTANCE MRBTSID
,CLOCK.SI2_SYNC_INPUT_PRIO
,CLOCK.SI2_SYNC_INPUT_TYPE
FROM
C_SRM_CLOCK_SI2_@OMC7 CLOCK INNER JOIN CTP_COMMON_OBJECTS@OMC7 CCLOCK ON CLOCK.OBJ_GID = CCLOCK.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 CSYNC ON CCLOCK.CO_PARENT_GID = CSYNC.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 CMNLENT ON CSYNC.CO_PARENT_GID = CMNLENT.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 CMNL ON CMNLENT.CO_PARENT_GID = CMNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC7 CMRBTS ON CMNL.CO_PARENT_GID = CMRBTS.CO_GID
WHERE
CLOCK.CONF_ID = 1

UNION ALL

SELECT
--*
'OMC9' OMC
,CMRBTS.CO_NAME BTSNAME
,CMRBTS.CO_OBJECT_INSTANCE MRBTSID
,CLOCK.SI2_SYNC_INPUT_PRIO
,CLOCK.SI2_SYNC_INPUT_TYPE
FROM
C_SRM_CLOCK_SI2_@OMC9 CLOCK INNER JOIN CTP_COMMON_OBJECTS@OMC9 CCLOCK ON CLOCK.OBJ_GID = CCLOCK.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 CSYNC ON CCLOCK.CO_PARENT_GID = CSYNC.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 CMNLENT ON CSYNC.CO_PARENT_GID = CMNLENT.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 CMNL ON CMNLENT.CO_PARENT_GID = CMNL.CO_GID
INNER JOIN CTP_COMMON_OBJECTS@OMC9 CMRBTS ON CMNL.CO_PARENT_GID = CMRBTS.CO_GID
WHERE
CLOCK.CONF_ID = 1
