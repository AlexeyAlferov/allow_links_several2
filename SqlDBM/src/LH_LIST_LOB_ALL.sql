-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_LIST_LOB_ALL
CREATE VIEW LH_LIST_LOB_ALL as

select  * from LH_LIST_LOB 

union all select 'All LOBs';
