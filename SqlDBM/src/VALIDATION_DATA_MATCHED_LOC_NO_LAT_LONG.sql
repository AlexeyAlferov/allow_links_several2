-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_DATA_MATCHED_LOC_NO_LAT_LONG
CREATE VIEW VALIDATION_DATA_MATCHED_LOC_NO_LAT_LONG as

select

  HS.fac_id as HS_FAC_ID,

  HS.FAC_NAME as HAULING_SITE_NAME,

  HS.CITY_NM as HAULING_SITE_CITY,

  HS.STATE_CD as HAULING_SITE_STATE,

  FAC.fac_id as DISPOSAL_FAC_ID,

  FAC.FAC_NAME as DISPOSAL_NAME,

  FAC.GEO_CITY_NM as DISPOSAL_CITY,

  FAC.GEO_STATE_CD as DISPOSAL_STATE,

  OCS_DISPOSAL_CD,

  OCS_DISPOSAL_NM,

  'No LAT/LONG for location matching, record with hauling site: ' || HS.FAC_ID || ' (' || HS.FAC_NAME || ',' || HS.CITY_NM || ',' || HS.STATE_CD ||

    ') and disposal facility: ' || FAC.FAC_ID || ' (' || NVL(FAC.FAC_NAME, '<no name>') || ',' || NVL(FAC.GEO_CITY_NM, '<no geo city>') || ',' ||

    NVL(FAC.GEO_STATE_CD, '<no geo state>') || ')'

    as DETAIL

from LOCATION_MATCHING LM

inner join HAULING_SITE HS on HS.fac_id = LM.HAULING_SITE_ID

--inner join MODEL_FACILITIES FAC_HS on FAC_HS.fac_id=HS.fac_id

inner join MODEL_FACILITIES FAC on FAC.fac_id = LM.matched_locationid_type

WHERE FAC.LATITUDE is null

;
