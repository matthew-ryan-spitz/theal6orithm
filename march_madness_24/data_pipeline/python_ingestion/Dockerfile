FROM python:3.9

RUN pip install numpy pandas sqlalchemy psycopg2 kaggle

WORKDIR /app
COPY ingest_data.py ingest_data.py

ENV user=${user}
ENV password=${password}
ENV host=${host}
ENV port=${port}
ENV db=${db}
ENV tables=${tables}

#ENTRYPOINT [ "python", "ingest_data.py" ]
CMD python -u ingest_data.py --user=$user --password=$password --host=$host --port=$port --db=$db --tables=$tables