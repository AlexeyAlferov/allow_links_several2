-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** SUBLOB_HIERARCHY
CREATE VIEW SUBLOB_HIERARCHY as (SELECT 
  "LOB", 
  "SUBLOB", 
  "SUBLOB_DESC", 
  "ESSBASE_SUBLOB_KEY", 
  "ESSBASE_SUBLOB_DESC" 
FROM (select LOB, SUBLOB, SUBLOB_DESC, ESSBASE_SUBLOB_KEY, ESSBASE_SUBLOB_DESC 
from DEV_ONEWM.MART.COMRES_LOB_HIERARCHY
union
select LOB, SUBLOB, SUBLOB_DESC, ESSBASE_SUBLOB_KEY, ESSBASE_SUBLOB_DESC 
from DEV_ONEWM.MART.RO_LOB_HIERARCHY
) AS "v_0000017686_0000143914");
