-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** TURN_TIME_DEFAULTS
CREATE VIEW TURN_TIME_DEFAULTS AS WITH CORP_DEFAULTS_MA AS 

(

--

-- Calculate the Market Area defaults

--

   SELECT

      FAC_TYPE,

      MARKET_AREA_CD,

      AVG(t1.CYCLE_MINUTE_CNT) AS CYCLE_MINUTE_CNT 

   FROM

      CORP_DISPOSAL_LOB t1,

      DISPOSAL_SITE t2 

   WHERE

      t1.FAC_ID = t2.FAC_ID 

      AND MARKET_AREA_CD IS NOT NULL AND MARKET_AREA_CD != '' -- Filter out bad market areas

   GROUP BY

      FAC_TYPE,

      MARKET_AREA_CD 

),

CORP_DEFAULTS_FAC_ID AS 

(

--

-- Calculate the Facility defaults - this is for facilities which have COMM and RES but not RO for example

-- It may create some unecessary defaults

--

   SELECT

      FAC_ID,

      AVG(CYCLE_MINUTE_CNT) AS CYCLE_MINUTE_CNT 

   FROM

      CORP_DISPOSAL_LOB

   GROUP BY

   	  FAC_ID

)

SELECT

   t1.FAC_ID,

   t3.LOB_CD,

   nvl(t4.CYCLE_MINUTE_CNT, t2.CYCLE_MINUTE_CNT) AS CYCLE_MINUTE_CNT , t4.CYCLE_MINUTE_CNT as c1, t2.CYCLE_MINUTE_CNT AS c2

FROM

   DISPOSAL_SITE t1 

   LEFT JOIN

      CORP_DEFAULTS_MA T2 

      ON T1.FAC_TYPE = T2.FAC_TYPE 

      AND T1.MARKET_AREA_CD = T2.MARKET_AREA_CD 

   LEFT JOIN 

   	  CORP_DEFAULTS_FAC_ID T4 

   	  ON T1.FAC_ID = T4.FAC_ID

   CROSS JOIN

      (

         SELECT 'COMMERCIAL' AS LOB_CD UNION SELECT 'RESIDENTIAL'  UNION SELECT 'ROLLOFF'

      )

      t3

WHERE t4.CYCLE_MINUTE_CNT IS NOT NULL OR t2.CYCLE_MINUTE_CNT IS NOT NULL;
