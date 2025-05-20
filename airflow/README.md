# Sales Pipeline - ETL Documentation

## Overview

This pipeline is built using **Apache Airflow** and designed to perform a full ETL process for sales data. It ingests data from CRM and ERP systems, transforms it using **dbt** into structured silver and gold layers, and loads it into **PostgreSQL**.

---

## Project Folder Structure

```bash

├── dags/               # Airflow DAGs
├── dbt/                # DBT models and configurations
├── datasets/           # Raw data files (CSV, JSON, etc.)
├── plugins/            # Custom Airflow plugins
├── logs/               # Airflow logs
├── Dockerfile          # Custom image definition
├── docker-compose.yml  # Compose file defining services
├── secrets.env         # Env variables for secure credentials
```


## 🚀 How to Run the Project Locally

Follow these steps to spin up the full ETL pipeline environment using Docker and Docker Compose:

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/nasr1231/ETL-Engine.git
```

### 2️⃣ Prepare Environment Variables

Create a `.env` file or `secrets.env` (as referenced in the `docker-compose.yml`) and add your sensitive environment variables:

```env
# secrets.env
AIRFLOW_UID=50000
_AIRFLOW_WWW_USER_USERNAME=airflow
_AIRFLOW_WWW_USER_PASSWORD=airflow
```

> 📁 The full `docker-compose.yaml` file can be found: [Here](docker-compose.yml).

### 3️⃣ Build the Custom Airflow Image

```bash
docker build -t engine-airflow-custom:latest .
```

> 💡 **Important:** Make sure your terminal's working directory is the same directory that contains the `Dockerfile`, otherwise the build will fail.

This builds a custom Airflow image that includes:
- dbt-core
- dbt-postgres
- airflow-dbt-python
- psycopg2
- pandas
- git
- flake8

### 4️⃣ Start the Services

```bash
docker-compose up -d
```

This command will:
- Start PostgreSQL and pgAdmin
- Initialize the Airflow metadata DB
- Launch Airflow webserver, scheduler, and worker
- Create the admin user automatically

### 5️⃣ Access the Services

| Tool        | URL                          | Default Credentials               |
|-------------|------------------------------|------------------------------------|
| Airflow     | [http://localhost:8080](http://localhost:8080) | `admin / admin`                   |
| pgAdmin     | [http://localhost:5050](http://localhost:5050) | `engine@admin.com / admin`        |
| Power BI    | Connect via PostgreSQL (host: `localhost`, port: `5432`) |

---

## DAG Structure

```python
dag_id = "sales_pipeline"
description = "ETL Engine"
tags = ['data_ingestion', 'sales']
schedule_interval = None
```

### Task Flow

#### 1. PostgreSQL Connection Test

- Uses `TaskFlow API`
- Ensures connection to the PostgreSQL database is successful before running the pipeline

#### 2. Ingest Data (Task Group)

**CRM Datasets Ingested:**

- `cust_info.csv` → `crm_cust_info`
- `prd_info.csv` → `crm_prd_info`
- `sales_details.csv` → `crm_sales_details`

**ERP Datasets Ingested:**

- `CUST_AZ12.csv` → `erp_cust_az12`
- `LOC_A101.csv` → `erp_loc_a101`
- `PX_CAT_G1V2.csv` → `erp_px_cat_g1v2`

#### 3. Test DBT Resources

- Executes `dbt debug` command to ensure the environment and project configuration are valid

#### 4. Silver Layer Transformations (Task Group)

**dbt models transformed:**
- `crm_cust_info`
- `crm_product_info`
- `crm_sales_details`
- `erp_customer_info`
- `erp_customer_locations`
- `erp_px_cat`

Each model undergoes:
- `dbt run`
- `dbt test`

#### 5. Gold Layer Load (Task Group)

**dbt models created:**
- `dim_customers`
- `dim_products`
- `dim_dates`
- `fact_sales`

Each model undergoes:
- `dbt run`
- `dbt test`

---

## Operators Used

- `@task` decorator from TaskFlow API
- `BashOperator` for executing dbt CLI commands

---

## Notes

- Secrets are loaded from `.env` file via `dotenv`
- Pipeline is structured using `TaskGroup` for modularity and clarity
- PostgreSQL credentials are handled securely via environment variables
  
---

## 📘 dbt Project Notes

- `--profiles-dir` and `--project-dir` were explicitly used in all dbt commands because the `profiles.yml` and dbt project directory were located in non-default paths.
- dbt Documentation Commands used:

```bash
dbt docs generate --profiles-dir /home/airflow/dbt --project-dir /home/airflow/dbt/sales

dbt docs serve --profiles-dir /home/airflow/dbt --project-dir /home/airflow/dbt/sales --port 8100 --host 0.0.0.0
```

> 💡 **Note**: The `--host` and `--port` settings were required to make the dbt docs UI accessible outside the container (on localhost:8100) due to the use of Docker and port mapping defined in `docker-compose.yaml`.

---
