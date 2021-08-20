CREATE TABLE IF NOT EXISTS demo_db.public.battery_level
AS
(SELECT
       TO_DATE(SPLIT_PART(tel.time_updated,' UTC',1)) AS date_key,
       st.city_name,
       st.country_name,
       COUNT(DISTINCT tel.vehicle_id) AS veh_low_battery
FROM DEMO_DB.PUBLIC.TBL_TELEMETRY tel
INNER JOIN DEMO_DB.PUBLIC.TBL_STATES st
ON tel.vehicle_id = st.vehicle_id
AND TO_DATE(SPLIT_PART(tel.time_updated,' UTC',1)) = TO_DATE(SPLIT_PART(st.time_updated,' UTC',1))
WHERE battery_level < 20
GROUP BY TO_DATE(SPLIT_PART(tel.time_updated,' UTC',1)),
         st.city_name,
         st.country_name
)