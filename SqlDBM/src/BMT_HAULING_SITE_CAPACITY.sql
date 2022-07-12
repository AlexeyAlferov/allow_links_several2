-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** BMT_HAULING_SITE_CAPACITY
CREATE VIEW BMT_HAULING_SITE_CAPACITY as
select * from
(select
FAC_ID ,
FAC_TYPE ,
LOB,
SUBLOB ,
TRUCK_CNT,
TRUCK_CAPACITY_CNT,
LAST_UPDATED_DTM ,
LAST_UPDATED_USER ,
DATA_COLLCTION_ADD_DELETE_UPDATE ,
row_number() over (partition by FAC_ID, SUBLOB order by last_updated_dtm desc nulls last) as rnk,
HOURS_PER_TRUCK,
PERCENTAGE_HOURS_ON_SAT AS PERCENTAGE_HOURS_ON_SAT,  -- values from the field are coming in as integers
VEHICLE_COST_PER_HOUR
 from STG.FACILITY_CAPACITY_BMT_DATA_COLLCTN
 )  where rnk=1;
