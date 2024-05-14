## Instructions to Run Data Pipeline Locally that Exports data to Google Cloud Storage and Google BigQuery

### 1. Build & Run Mage Image locally
docker-compose up -d --build magic (after navigating to march_madness_24/data_pipeline)

### 2. Go to Local Mage Environment
http://localhost:6789/
- copies of all files to execute Mage pipelines exist in march_madness_24/data_pipeline/mage_orchestration/project

### 3. Go to Pipelines within Mage and Trigger api_to_gcs pipeline
http://localhost:6789/pipelines/api_to_gcs/triggers/4
- this pipeline will load data from Kaggle and save to GCS data lake

### 4. At end of the api_to_gcs pipeline another pipeline is automatically triggered, gcs_to_bigquery
this pipeline will load data from GCS data lake, clean the data, and load to data warehouse, BigQuery
- BigQuery location: stg_march_madness_2024 dataset

### 5. At end of the gcs_to_bigquery pipeline another pipeline is automatically triggered, dbt_transformations
this pipeline will transform the data within the data warehouse and prepare it for analytic consumption and export it back to data warehouse, BigQuery

- DBT transformations: march_madness_24/data_pipeline/mage_orchestration/project/dbt/
- BigQuery location: prod_march_madness_2024 dataset

### 6. Build & Run Metabase Image locally
docker-compose up -d --build metabase (after navigating to march_madness_24/data_pipeline)

### 7. Connect Metabase to BigQuery and Create Dashboard
copy of an example dashboard saved in march_madness_24/dashboard

### Next Steps
- connect Mage & Metabase to Cloud
- use data for ML model
