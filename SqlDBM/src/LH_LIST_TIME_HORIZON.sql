-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_LIST_TIME_HORIZON
CREATE VIEW LH_LIST_TIME_HORIZON as
select 'Hourly' TIME_HORIZON_NM
union all select 'Daily'
union all select 'Monthly'
union all select 'Quarterly'
union all select 'Yearly';
