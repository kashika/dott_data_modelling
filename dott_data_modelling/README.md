# This document is created to highlight the steps taken to do the dott data modelling challenge

# input is two data sources - tbl_states & tbl_telemetry.
The size of these files are huge, so I have segregated the files into files with record counts of 500k. The logic to
split these files is written in python/split_states.py and python/split_telemetry.py

COMMANDS -

python3 python/states.py
python3 python/telemetry.py

# connection to Snowflake account -
For the purpose of this project, I have created a snowflake account. The connection details to connect snowflake to dbt 
is documented in dbt_project.yml .The location where ethe files are located can be seen in dbt_projrct.yml. While 
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
The dbt seed command loaded all the records in 500k batches in the snowflake datbase. To create a common dataset i 
loaded all the records in raw_tbl_states dataset. Refer -models/raw_tbl_states.sql.


