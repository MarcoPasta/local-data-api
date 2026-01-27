FROM tiangolo/uvicorn-gunicorn:python3.11-slim

LABEL maintainer="https://github.com/marcopasta"

ENV MODULE_NAME local_data_api.main

# This app supports only single process to share connections on workers
ENV WEB_CONCURRENCY 1

RUN  mkdir -p /usr/share/man/man1 \
     && apt-get update && apt-get install -y default-jre libpq-dev  \
     && savedAptMark="$(apt-mark showmanual)" \
     && apt-get install -y gcc g++ curl \
     && pip install JPype1 psycopg2\
     && curl -o /usr/lib/jvm/postgresql-java-client.jar \
        https://jdbc.postgresql.org/download/postgresql-42.2.8.jar \
     && apt-mark auto '.*' > /dev/null \
     && apt-mark manual $savedAptMark \
     && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false  \
     && apt-get autoremove -y \
     && rm -rf /var/lib/apt/lists/*


COPY pyproject.toml /app
COPY ./requirements-dev.txt /app

COPY LICENSE /app
WORKDIR /app

RUN pip install --upgrade pip
RUN pip install -r requirements-dev.txt
RUN pip install .

COPY local_data_api /app/local_data_api
