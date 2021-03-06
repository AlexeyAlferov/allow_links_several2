-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** TRASFER_LANES_MIN_MAX_VOLUME_TO_MODEL
CREATE VIEW TRASFER_LANES_MIN_MAX_VOLUME_TO_MODEL AS 
select volume_day_lvl.LANE_DESTINATION_FAC_ID,
       volume_day_lvl.LANE_DESTINATION_FAC_TYPE,
	   volume_day_lvl.WASTE_TYPE,
       MIN_TONS * nvl(FACILITY_OPERATIONAL_DAYS_IN_SCOPE,1) MIN_TONS, 
       MAX_TONS * nvl(FACILITY_OPERATIONAL_DAYS_IN_SCOPE,1) MAX_TONS
from                    
(select
TSFRLN.LANE_DESTINATION_FAC_ID, 
TSFRLN.LANE_DESTINATION_FAC_TYPE,
TSFRLN.WASTE_TYPE,
MIN_TONS/volume_adjust_factor MIN_TONS, 
MAX_TONS/volume_adjust_factor MAX_TONS
from mart.LH_TRANSFER_LANE_WASTE_TYPE TSFRLN
left join mart.FACILITY_VOLUME_CONSTRAINT_ADJUST_FACTOR adj 
on adj.FAC_ID =TSFRLN.LANE_DESTINATION_FAC_ID
and adj.FAC_TYPE=TSFRLN.LANE_DESTINATION_FAC_TYPE
) volume_day_lvl
left join FACILITY_OPERATION_DAYS_IN_SCOPE oprntl_days
on volume_day_lvl.LANE_DESTINATION_FAC_ID = oprntl_days.FAC_ID
and volume_day_lvl.LANE_DESTINATION_FAC_TYPE = oprntl_days.FAC_TYPE;
