-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** test_sj
CREATE VIEW test_sj  as

select red.SITE_CD as DepotFacId

	, count(red.rte_num) routes 

	, sum(red.DSPSL_TRIP_CNT) disposal_trips

	, sum(red.total_equivalent_haul_num) eq_hauls

	, cast(sum(red.total_equivalent_haul_num)/count(red.rte_num) as numeric(10,2)) as eq_hauls_per_route_N

from STG.PVW_FCT_DAY_RTE_EXECUTION_DRVR red 

where red.SUB_LOB_CD like 'RO%' 

	and red.RTE_EXECUTION_SVC_DT between '2019-10-01' and '2019-12-31'

  and (depotfacid in (select fac_idu from site_parms where group_key in  ('S04136','S03789','S03752','S04547','S07288','S04058','S04249','S04069','S03825','S03227','S02928','S09205','S06991','S04107','S05636','S04058') )  or (1 in ('COMMERCIAL','RESIDENTIAL','ROLLOFF')))

group by DepotFacId;
