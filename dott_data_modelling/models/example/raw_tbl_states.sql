-- Sample command to run this script -
-- dbt run --models raw_tbl_states

{{ config(materialized='table') }}

with states as(
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES1"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES2"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES3"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES4"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES5"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES6"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES7"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES8"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES9"
 UNION
 select *  from "DEMO_DB"."PUBLIC"."DATA_MODELLING_TEST_TBL_STATES10"
)
select * from states