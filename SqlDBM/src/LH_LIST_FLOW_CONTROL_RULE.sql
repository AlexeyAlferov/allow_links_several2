-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** LH_LIST_FLOW_CONTROL_RULE
CREATE VIEW LH_LIST_FLOW_CONTROL_RULE 

as

SELECT SRC || ' - ' || DEST as RULE_TYPE

FROM LH_LIST_FLOW_CONTROL_RULE_SRC cross join LH_LIST_FLOW_CONTROL_RULE_DEST;
