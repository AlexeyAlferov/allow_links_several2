-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** model_hrs_cap
CREATE VIEW model_hrs_cap AS

 SELECT

     ROW_NUMBER() OVER (ORDER BY mdl.fac_id) AS hrs_cap_id

     ,1 AS case_id

     ,mdl.fac_id

     ,mdl.SUBLOB

     ,0 AS MIN_HRS

     ,(

         hs.TRUCK_CNT * NVL(hs.HOURS_PER_TRUCK, 10) --WEEKDAYS

         * COUNTDAYS($start_date, $end_date, 0)

       + hs.TRUCK_CNT * NVL(hs.HOURS_PER_TRUCK, 10) --SATURDAYS

         * COUNTDAYS($start_date, $end_date, 1)

         * NVL(hs.PERCENTAGE_HOURS_ON_SAT, 0.5)

      ) AS TRUCK_CAPACITY  -- Truck capacity is backing out average hours per truck to total hours

     ,c.TOTAL_COLLECTION_HRS

     ,COALESCE(TRUCK_CAPACITY - COALESCE(c.TOTAL_COLLECTION_HRS,0), 9999999) AS MAX_HRS

 FROM MODEL_DEPOT_LOB mdl

 LEFT JOIN HAULING_SITE_CAPACITY hs

     ON REPLACE(mdl.FAC_ID,'_Depot') = hs.FAC_ID AND mdl.SUBLOB=hs.SUBLOB

 LEFT JOIN SUB_LOB_HRS_JOINED c ON REPLACE(mdl.FAC_ID,'_Depot') =c.HAULING_SITE AND mdl.SUBLOB = c.SUBLOB

 WHERE UPPER(mdl.FAC_ID)!='3PDEPOT';
