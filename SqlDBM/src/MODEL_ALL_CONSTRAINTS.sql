-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** MODEL_ALL_CONSTRAINTS
CREATE VIEW MODEL_ALL_CONSTRAINTS AS

WITH UNIONED_CONSTRAINTS AS

(

--All global facility constraints (all waste types)

SELECT

    'GLOBAL_FACILITY_CONSTRAINT' AS SRC,

    FAC_ID,

    FAC_TYPE,

    'ALL' AS WASTE_TYPE,

    MIN_TONS,

    MAX_TONS,

    VOLUME_CONSTRAINT_TYPE,

    VOLUME_TIME_UNIT,

    NOTES

FROM DISPOSAL_SITE_CONSTRAINTS

UNION ALL

--All waste-"type" specific min / max tonnage constraints

SELECT

    'WASTE_TYPE' AS SRC,

    FAC_ID,

    FAC_TYPE,

    WASTE_TYPE,

    MIN_TONS,

    MAX_TONS,

    VOLUME_CONSTRAINT_TYPE,

    VOLUME_TIME_UNIT,

    NOTES

FROM WASTE_TYPE_CONSTRAINTS

),

UNIONED_SCALED_CONSTRAINTS AS (

SELECT

c.SRC,

c.FAC_ID,

c.WASTE_TYPE,

c.MIN_TONS,

c.MAX_TONS,

c.VOLUME_TIME_UNIT,

c.VOLUME_CONSTRAINT_TYPE,

c.NOTES,

c.MIN_TONS*(

    CASE

        WHEN UPPER(c.VOLUME_TIME_UNIT)='HOURLY' THEN sc_fac.HOURLY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='DAILY' THEN sc.DAILY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='MONTHLY' THEN sc.MONTHLY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='QUARTERLY' THEN sc.QTR_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='YEARLY' THEN sc.YEARLY_FACTOR

    ELSE 1 END

) AS MIN_TONS_SCALED,

c.MAX_TONS*(

    CASE

        WHEN UPPER(c.VOLUME_TIME_UNIT)='HOURLY' THEN sc_fac.HOURLY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='DAILY' THEN sc.DAILY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='MONTHLY' THEN sc.MONTHLY_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='QUARTERLY' THEN sc.QTR_FACTOR

        WHEN UPPER(c.VOLUME_TIME_UNIT)='YEARLY' THEN sc.YEARLY_FACTOR

    ELSE 1 END

) AS MAX_TONS_SCALED

FROM UNIONED_CONSTRAINTS c

LEFT JOIN SCALE_CONSTRAINTS sc

LEFT JOIN SCALE_CONSTRAINTS_FACILITIES sc_fac on c.FAC_ID=SC_FAC.FAC_ID

WHERE c.FAC_ID IN (SELECT FAC_ID FROM MODEL_FACILITY_LIST))

SELECT

SRC,

FAC_ID,

WASTE_TYPE,

MIN_TONS,

MAX_TONS,

VOLUME_TIME_UNIT,

VOLUME_CONSTRAINT_TYPE,

NOTES,

MIN_TONS_SCALED,

MAX_TONS_SCALED,

MIN(MAX_TONS_SCALED) OVER (PARTITION BY SRC, FAC_ID, WASTE_TYPE) AS GOVERNING_MAX, --pick the smallest max - NB can be multiple

MAX(MIN_TONS_SCALED) OVER (PARTITION BY SRC, FAC_ID, WASTE_TYPE) AS GOVERNING_MIN, --pick the largest min - NB can be multiple

CASE WHEN MIN_TONS_SCALED = GOVERNING_MIN THEN 1 ELSE 0 END AS GOVERNING_MIN_FLAG,

CASE WHEN MAX_TONS_SCALED = GOVERNING_MAX THEN 1 ELSE 0 END AS GOVERNING_MAX_FLAG

FROM UNIONED_SCALED_CONSTRAINTS s

;
