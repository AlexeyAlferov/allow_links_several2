-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_DATA_SUSPICIOUS_LOC_MATCH
CREATE VIEW VALIDATION_DATA_SUSPICIOUS_LOC_MATCH AS
select
	HS.fac_id as HS_FAC_ID,
	LM.OCS_DISPOSAL_CD,
	HAVERSINE(HS.LATITUDE, HS.LONGITUDE, FAC.LATITUDE, FAC.LONGITUDE)*(0.62) AS GREAT_CIRCLE_MILES,
	'Hauling site '||HS.FAC_ID||' with disposal code '||LM.OCS_DISPOSAL_CD||' maps to disposal site '||FAC.FAC_ID||' which is '||CAST(GREAT_CIRCLE_MILES AS DECIMAL(8,2))||' miles away. Hauling Site Detals: '||
	HS.FAC_ID||', '||nvl(HS.FAC_NAME,'')||', '||nvl(HS.GEO_CITY_NM,'')||', '||nvl(HS.GEO_STATE_CD,'')||'. Disposal Site Details: '||
	FAC.FAC_ID||', '||nvl(FAC.FAC_NAME,'')||', '||nvl(FAC.GEO_CITY_NM,'')||', '||nvl(FAC.GEO_STATE_CD,'')||'. It accounts for '|| MCP.NUMBER_OF_RECORDS ||
    ' collection points and ' || MCP.TOTAL_TONNAGE||' Tons' AS DETAIL
	,SUBSTR(HS.FAC_ID,1,6) AS LH_PARM_1
	,'COLLECTION'  AS LH_PARM_2
    ,LM.OCS_DISPOSAL_CD AS LH_PARM_3
    ,NULL AS LH_PARM_4
	,NULL AS LH_PARM_5
from LOCATION_MATCHING LM
inner join HAULING_SITE HS on HS.fac_id = LM.HAULING_SITE_ID
inner join MODEL_FACILITIES FAC on FAC.fac_id = LM.matched_locationid_type
inner join (SELECT DEPOTFACID, OCS_DISPOSAL_CD, COUNT(*) AS NUMBER_OF_RECORDS, SUM(TONS) AS TOTAL_TONNAGE
       FROM MODEL_COLLECTION_POINTS
       GROUP BY DEPOTFACID, OCS_DISPOSAL_CD, DISPFACID) MCP
	   on (LM.HAULING_SITE_ID = SUBSTR(MCP.DEPOTFACID,1,6) and LM.OCS_DISPOSAL_CD = MCP.OCS_DISPOSAL_CD)
WHERE GREAT_CIRCLE_MILES > 100.0
;
