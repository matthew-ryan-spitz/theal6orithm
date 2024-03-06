import os
import argparse

import pandas as pd
from sqlalchemy import create_engine

def main(params):

    # automatically pull data from Kaggle API
    #kaggle_dataset = params.kaggle_dataset
    #kaggle_username = params.kaggle_username

    #os.system(f"kaggle competitions download -c {dataset}")

    # create conection with postgres
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db = params.db
    datasets = params.datasets

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    
    # upload files to postgres
    directory = str(os.fsencode('data'), 'utf-8')
    for file in os.listdir(directory):
        # need to turn datasets variable from list of 1 ['dataset1,dataset2'] to list of n ['dataset1','dataset2']
        if file in datasets[0].split(','):
            with pd.read_csv('data/' + file, chunksize=100000) as reader:
                load = 0
                for chunk in reader:
                    if load == 0:
                        # load schema to postgres
                        chunk.head(n=0).to_sql(name=file.split('.')[0], con=engine, if_exists='replace')
                    # load data to postgres
                    chunk.to_sql(name=file.split('.')[0], con=engine, if_exists='append')
                    load += 1
            reader.close()
            print('done: {}'.format(file))


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Ingest data from Kaggle to Postgres')

    #parser.add_argument('--kaggle_dataset', required=True, help='kaggle competiton name where data is located')
    #parser.add_argument('--kaggle_username', required=True, help='kaggle username')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True, help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True, help='database name for postgres')

    parser.add_argument('--datasets', nargs="*", type=str, required=True, help='datasets to create from Kaggle data')

    args = parser.parse_args()

    main(args)