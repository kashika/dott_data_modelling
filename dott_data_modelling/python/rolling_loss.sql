
CREATE TABLE IF NOT EXISTS demo_db.public.rolling_loss
AS
(

    WITH dates AS
    (SELECT TO_DATE(SPLIT_PART(time_updated,' UTC',1)) AS all_dates
            FROM "DEMO_DB"."PUBLIC".TBL_STATES
            GROUP BY TO_DATE(SPLIT_PART(time_updated,' UTC',1))
    )


   SELECT avg_dep.all_dates,
          avg_dep.city_name,
          avg_dep.country_name,
          round((rolling_loss.cnt_rolling_loss * 100.00)/avg_dep.avg_deployed,2) as running_loss_pct
          FROM
           (SELECT
             dates.all_dates,
             dep.city_name,
             dep.country_name,
             round(AVG(CASE WHEN date_key BETWEEN dates.all_dates - 21 AND dates.all_dates-7 THEN deployed_vehicle ELSE NULL END),0) AS avg_deployed
             FROM
             dates
             LEFT JOIN
             (SELECT TO_DATE(SPLIT_PART(time_updated,' UTC',1)) as date_key,
                     city_name,
                     country_name,
                     COUNT(DISTINCT vehicle_id) AS deployed_vehicle
                     FROM DEMO_DB.PUBLIC.TBL_STATES
                     WHERE is_deployed='TRUE'
                     GROUP BY TO_DATE(SPLIT_PART(time_updated,' UTC',1)),
                         city_name,
                         country_name
             )dep
             ON dates.all_dates>=dep.date_key
             GROUP BY dates.all_dates,
                      dep.city_name,
                      dep.country_name
           )avg_dep


        LEFT JOIN



        (SELECT
          dates.all_dates,
          daily_loss.city_name,
          daily_loss.country_name,
          COUNT(DISTINCT CASE WHEN daily_loss.all_dates BETWEEN dates.all_dates - 21 AND dates.all_dates-7
                             THEN daily_loss.lost_vehicle ELSE null END) AS cnt_rolling_loss
          FROM  dates
          LEFT JOIN
          demo_db.public.daily_loss as daily_loss

         ON dates.all_dates>=daily_loss.all_dates
         GROUP BY  dates.all_dates,
                   daily_loss.city_name,
                   daily_loss.country_name
        )rolling_loss

ON avg_dep.all_dates = rolling_loss.all_dates
)