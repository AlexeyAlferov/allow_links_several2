-- ******************** SqlDBM: Microsoft SQL Server ********************
-- ************************* Generated by SqlDBM ************************


-- ************************************** PMT_DISPOSAL_3P
CREATE VIEW PMT_DISPOSAL_3P as

WITH filtered_rollup AS

( SELECT *

FROM stg.pmt_disposal_rollup

WHERE data_dt BETWEEN 

        get_3p_start_date(

              $num_weeks_3p

            , $start_date

            , $end_date

            , get_3p_end_date($num_weeks_3p, $start_date, $end_date,

                           (SELECT MAX(data_dt) FROM stg.pmt_disposal_rollup))

            ) AND

            get_3p_end_date($num_weeks_3p, $start_date, $end_date,

                            (SELECT MAX(data_dt) FROM stg.pmt_disposal_rollup))

    AND (tons_ext_msw + tons_ext_cd + tons_ext_spw + tons_ext_rgc + tons_ext_rdw) > 0

    AND UPPER(ROLLUP_TYPE)='W' --Use weekly totals only, E is cumulative and M is monthly

),

    pmt_disposal_exploded AS

(

    SELECT *

    FROM filtered_rollup

    UNPIVOT(third_party FOR waste_type 

        IN (tons_ext_msw, tons_ext_cd, tons_ext_spw, tons_ext_rgc, tons_ext_rdw)

    )

)

SELECT fac_idu || '_Disposal'        AS fac_id

    , DATE_PART('weekday', data_dt) AS day_of_week

    , CASE

        WHEN waste_type = 'TONS_EXT_CD' THEN 'C&D'

        ELSE UPPER(REGEXP_SUBSTR(waste_type, 'tons_ext_\([[:alnum:]]+\)', 1, 1, 'i',1))

      END AS waste_type

    , AVG(third_party)/6 AS avg_third_party --Average across the weeks and divide the average by 6 (excludes Sundays) to get a daily average

FROM pmt_disposal_exploded

GROUP BY fac_id, day_of_week, waste_type

ORDER BY fac_id, day_of_week, waste_type;
