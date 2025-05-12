
### 6️⃣ Project Folder Structure

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

