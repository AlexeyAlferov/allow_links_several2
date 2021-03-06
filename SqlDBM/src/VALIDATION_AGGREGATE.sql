-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** VALIDATION_AGGREGATE
CREATE VIEW VALIDATION_AGGREGATE AS
SELECT
   VM.VALIDATION_ID as VALIDATION_ID
  ,VM.SORT_ORDER as SORT_ORDER
  ,VM.test_TYPE as test_TYPE
  ,VM.test_NAME as test_NAME
  ,NVL(VAL.PASS,1) as PASS
  ,NVL(VAL.ROW_COUNT, 0) as ROW_COUNT
FROM VALIDATION_METADATA VM
LEFT JOIN
  (
    SELECT VD.VALIDATION_ID
            ,VD.SORT_ORDER
            ,VD.test_TYPE
            ,VD.test_NM AS test_NAME
            ,COUNT(*)=0 AS PASS
            ,COUNT(*) AS ROW_COUNT
      FROM VALIDATION_DETAIL VD
      GROUP BY VD.VALIDATION_ID, VD.SORT_ORDER, VD.test_NM, VD.test_TYPE
    ORDER BY VD.SORT_ORDER
   ) VAL
ON VAL.VALIDATION_ID=VM.VALIDATION_ID
ORDER BY VM.SORT_ORDER
;
