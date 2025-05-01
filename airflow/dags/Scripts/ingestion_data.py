import pandas as pd
from Scripts.postgres_conn import * 
import os
import logging


def ingest_data(path, table_name, post_connn, post_engine):
    try:
        file_name = os.path.basename(path)

        if is_processed(post_connn, file_name): # Checking the file if it's processed or not
            logging.info(f"{file_name} has already been processed. Skip!")
            return 
        
        logging.info(f"Data ingestion started: {file_name} into {table_name}")

        df = pd.read_csv(path)

        raw_data_insert(table_name, df, post_connn, post_engine)
        mark_file_as_processed(post_connn, file_name)

        logging.info(f"successful data ingestion into {table_name}")

    except Exception as e:
        logging.error(f"Error ingesting data from {file_name} into {table_name}: {e}")
