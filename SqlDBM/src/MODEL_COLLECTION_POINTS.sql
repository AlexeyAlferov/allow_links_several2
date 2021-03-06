-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** MODEL_COLLECTION_POINTS
CREATE VIEW MODEL_COLLECTION_POINTS as

SELECT

    ROW_NUMBER() OVER (ORDER BY --TODO: elaborate sort order to ensure consistent ROWNUMBER

    GROUP_ID,

    ROUTEID,

    DEPOTFACID,

    DISPFACID,

    WM_COLLECTION_FLAG,

    LOB,

    SUBLOB,

    WASTE_TYPE,

    TONS, --this should be sufficient2

    NBRLOADS,

    LOAD_SEQ,

    OCS_DISPOSAL_CD,

    DISPOSAL_TRIP_TYPE_CD) AS ROWNUMBER

    , *

 FROM (

		SELECT CC.* FROM COLLATED_CPS CC

		LEFT JOIN DISPOSAL_SITE DS

			ON CC.DISPFACID = DS.FAC_ID AND CC.LOB = 'ROLLOFF'

		WHERE NOT (CC.DCO_FROZEN_FLAG = 1 AND DS.ACTIVE_FLAG ='I')



		UNION ALL



		SELECT * FROM THIRD_PARTY_CPS  -- filter 3rd party by the disposal facilities from the regular COLLATED_CPS

		WHERE dispfacid IN (SELECT DISTINCT dispfacid FROM COLLATED_CPS)

		AND dispfacid in (select fac_id from DISPOSAL_SITE where active_flag='A')

  );
