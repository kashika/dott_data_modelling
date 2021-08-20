# This document is created to highlight the steps taken to do the dott data modelling challenge

# Provided input - two data sources - tbl_states & tbl_telemetry.
The size of these files are huge, so I have segregated the input files into files with record counts of 500k. 
The logic to split these files is written in python/split_states.py and python/split_telemetry.py

COMMANDS -

python3 python/states.py
python3 python/telemetry.py

# Connection to Snowflake account -
For the purpose of this project, I have created a snowflake account. The connection details to connect snowflake to dbt 
is documented in dbt_project.yml .The location where the files are located can be seen in dbt_projrct.yml. While 
initializing the dbt project via dbt init, i also created a profiles.yml to give details for snowflake account -


--------------------------------------
my-snowflake-db:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: bga49113.us-east-1

      # User/password auth
      user: 
      password: 

      role: ACCOUNTADMIN
      database: DEMO_DB
      warehouse: COMPUTE_WH
      schema: PUBLIC
      threads: 20
      client_session_keep_alive: False
      # query_tag: [anything]
--------------------------------------

Initialization 

- dbt init dott_data_modelling
- dbt seed - This loads all the csv files present in the data folder into the snowflake account in a tabular format.


# Loading data into Raw Layer
The dbt seed command loaded all the records in 500k batches in the snowflake database. To create a common dataset I 
loaded all the records in raw_tbl_states & raw_tbl_telemetry datasets. Schema for these table is defined in schema.yml file. 
Refer - models/raw_tbl_states.sql & models/raw_tbl_telemetry.sql
These datasets are in raw format and are loaded as it is with no modifications.

Commands-
dbt run --models raw_tbl_states 
dbt run --models raw_tbl_telemetry 
 
 
# Incremental Load
The process mentioned above to load files in the raw layer is effective for one time history load. Inorder to make this 
effective for daily loads, the files will have to be loaded incrementally. The logic for this is written in 
raw_tl_states_delta.sql & raw_tbl_telelmetry_delta

dbt run --models raw_tbl_states_delta --vars '{"START_DATE":"2020-12-31", "END_DATE":"2021-01-31"}'
dbt run --models raw_tbl_telemetry_delta --vars '{"START_DATE":"2020-12-31", "END_DATE":"2021-01-31"}'


# transformation Tables
The records are loaded into the transformation tables in incremental fashion with the column data types modified as 
per the details provided in the instructions document



# Creating staging datasets
All staging datasets are created with naming convention 's_'. These are truncate and load tables and are fully refreshed 
every time the scripts are run. These datasets have dynamic variables with the names 'START_DATE' & 'END_DATE'.
The command to run each module is provided in the scripts as comments

1. s_calender - list of all dates in the incremental load
2. s_agg_vehicle_loss_daily - count of lost vehicles on a daily level in each city/country
3. s_agg_vehicle_runn_loss_daily - 14 day running loss percentage on a daily level in each city/country
4. s_agg_vehicle_battery_level_daily - vehicles with battery level less that 20% in each city/country
5. s_agg_vehicle_loss_weekly - ount of lost vehicles on a weekly level in each city/country



# Final datasets-
1. agg_vehicle_performance_metric_daily - Final daily dataset
2. agg_vehicle_performance_metric_weekly - Final weekly dataset



# Future Work - 
1. A data quality check layer needs to be created to validate whether the total records, checksum and data
integrity is maintained while loading the records in raw layer and transformed layers

2. A process control logic should be added to make sure that if data is not fully loaded because of resource/
infrastructure issues, then the process works smoothly. Duplicate records cannot be added and no data can be missed 
while loading records. The best way for this is to use leverage managed services like Aurora or a similar dtabase, or
a custom logic can be created to make sure the process works smoothly