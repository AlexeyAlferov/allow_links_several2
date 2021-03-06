-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** MARKET_AREA_SITE_PROXIMITY
CREATE VIEW MARKET_AREA_SITE_PROXIMITY as

SELECT

  HAVERSINE(HS.LATITUDE, HS.LONGITUDE, DS.LATITUDE, DS.LONGITUDE)*(0.62) AS DIST_MILES,

  HS.FAC_ID HAULING_FAC_ID,

  DS.FAC_ID DISPOSAL_FAC_ID

FROM MART.HAULING_SITE HS

CROSS JOIN MART.DISPOSAL_SITE DS

WHERE DS.fac_type in ('Disposal','TS')

    AND UPPER(DS.ACTIVE_FLAG) = 'A'

	AND HS.MARKET_AREA_CD = $MARKET_AREA

	AND DIST_MILES <= $RANGE

    AND (DS.LATITUDE !=0 AND DS.LONGITUDE!=0)

    AND (DS.LATITUDE IS NOT NULL AND DS.LONGITUDE IS NOT NULL)

;
