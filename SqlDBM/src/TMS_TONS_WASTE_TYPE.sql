-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** TMS_TONS_WASTE_TYPE
CREATE VIEW TMS_TONS_WASTE_TYPE as (SELECT 
  "TRANSFER_DATE", 
  "LANE_ORIGIN_FAC_ID", 
  "LANE_DESTINATION_FAC_ID", 
  "WASTE_TYPE", 
  "TONS" 
FROM (SELECT 
	POS_TIME_IN_DATE::DATE AS TRANSFER_DATE, 	
	ORIGIN_SITE_ID||'_TS' as LANE_ORIGIN_FAC_ID,
	DESTINATION_SITE_ID||'_' ||case  when DESTLOCTYPECD = 'MRF Recycling'   then 'MRF' else DESTLOCTYPECD end as LANE_DESTINATION_FAC_ID,
	CASE WHEN PMT_CATEGORY = 'MSW' THEN 'MSW'
			WHEN PMT_CATEGORY = 'C&D' THEN 'C&D'
			WHEN PMT_CATEGORY = 'Sp. Waste' THEN 'SPW'
			WHEN PMT_CATEGORY IN ('Other','Non-PMT') 
		THEN CASE WHEN upper(POS_COMMODITY_DESC) LIKE '%MSW%' THEN 'MSW'
			WHEN upper(POS_COMMODITY_DESC) LIKE '%TRASH%' THEN 'MSW'
			WHEN upper(POS_COMMODITY_DESC) LIKE '%C&D%' THEN 'C&D'
			WHEN upper(POS_COMMODITY_DESC) LIKE '%DEMO%' THEN 'C&D'
			WHEN upper(POS_COMMODITY_DESC) LIKE '%CD%' THEN 'C&D'
			WHEN upper(POS_COMMODITY_DESC) LIKE '%SPECIAL' THEN 'SPW'
		ELSE PMT_CATEGORY||'-'||POS_COMMODITY_NM||'-'||POS_COMMODITY_DESC
		END
	END AS WASTE_TYPE,
	sum(tons) AS TONS
FROM  DEV_TMS.ODS.TMS_TONS
WHERE ORIGLOCTYPECD = 'Transfer Station'
AND DESTLOCTYPECD != 'Transfer Station'
AND WASTE_TYPE IN ('MSW','C&D','SPW')
AND TONS > 0
GROUP BY TRANSFER_DATE, LANE_ORIGIN_FAC_ID ,LANE_DESTINATION_FAC_ID, WASTE_TYPE
) AS "v_0000017686_0000304588");
