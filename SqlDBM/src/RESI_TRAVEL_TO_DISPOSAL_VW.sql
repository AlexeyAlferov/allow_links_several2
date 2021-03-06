-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** RESI_TRAVEL_TO_DISPOSAL_VW
CREATE VIEW RESI_TRAVEL_TO_DISPOSAL_VW as 

SELECT LANDFILL_PKEY, 

TIMESTAMPDIFF(MINUTE, EVENT_BEFORE_LANDFILL, ARRIVE) TRAVEL_TO_DSPSL_MINUTE, 

TIMESTAMPDIFF(MINUTE, DOWNSTART,DOWNEND) DOWN_TIME,

TIMESTAMPDIFF(MINUTE, LUNCHSTART,LUNCHEND) MEAL_TIME,

CASE WHEN (DOWNSTART BETWEEN LUNCHSTART AND LUNCHEND) AND (DOWNEND BETWEEN LUNCHSTART AND LUNCHEND)

     THEN MEAL_TIME - NVL(DOWN_TIME, 0)

     ELSE MEAL_TIME 

END NET_MEAL_TIME,

CASE WHEN (LUNCHSTART BETWEEN DOWNSTART AND DOWNEND) AND (LUNCHEND BETWEEN DOWNSTART AND DOWNEND)

	 THEN DOWN_TIME - NVL(MEAL_TIME,0) 

	 ELSE DOWN_TIME

END NET_DOWN_TIME,

TRAVEL_TO_DSPSL_MINUTE - NVL(NET_MEAL_TIME,0) - NVL(NET_DOWN_TIME,0) NET_TRAVEL_TO_DSPS

              

FROM 

MART.RESI_TRAVEL_TO_DISPOSAL_MOST_RECENT_EVENT T1



LEFT JOIN STG.TP_RO_DOWNTIME ROD

ON ROD.FK_ROUTEORDER = T1.FK_ROUTEORDER 

AND ROD.FK_VEHICLE IS NULL 

AND ROD.DOWNSTART  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE

AND ROD.DOWNEND  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE 

LEFT JOIN STG.TP_RO_LUNCH RLUNCH

ON RLUNCH.FK_ROUTEORDER = T1.FK_ROUTEORDER 

AND RLUNCH.LUNCHSTART BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE 

AND RLUNCH.LUNCHEND  BETWEEN T1.EVENT_BEFORE_LANDFILL AND T1.ARRIVE

AND RLUNCH.FK_VEHICLE IS NULL 

;
