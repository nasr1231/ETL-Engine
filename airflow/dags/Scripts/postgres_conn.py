from sqlalchemy import create_engine,text
from sqlalchemy.exc import SQLAlchemyError
import logging


def postgres_connection(host, db_name, user, password):

    connection_string = f'postgresql://{user}:{password}@{host}/{db_name}'

    try:
        engine = create_engine(connection_string)
        postgresql_conn = engine.connect()
        
        ### Logging Connection Status
        logging.info("Connected to PostgreSQL db successfully")
        return postgresql_conn, engine
    
    except SQLAlchemyError as error:
        logging.error("Error while connecting to PostgreSQL: %s", error)
        return None, None
    
def close_connection(connection, engine):
    if connection:
        connection.close()
        logging.info("connection is closed")
    if engine:
        engine.dispose()
        logging.info("SQLAlchemy engine disposed")


def raw_data_insert(table_name,data_frame,connection,engine):
    logging.info(f"loading raw data into table {table_name}")

    if connection:
        try:
            data_frame.to_sql(name=f'table_name', con=engine, if_exists='append', schema='bronze', index=False)
            logging.info(f"raw data loaded successfully into {table_name} with {len(data_frame)} rows")
        except SQLAlchemyError as e:
            logging.error(f"error while load raw data : {e} ")
    else:
        logging.error(f"Failed to connect to the database and load data into table {table_name}")


def is_processed(conn, file_name):
    query = text("SELECT 1 FROM bronze.processed_files WHERE file_name = :file_name")
    result = conn.execute(query, {'file_name': file_name}).fetchone()
    return result is not None

def mark_file_as_processed(conn, file_name):
    query = text("INSERT INTO bronze.processed_files (file_name) VALUES (:file_name)")
    conn.execute(query, {'file_name': file_name})