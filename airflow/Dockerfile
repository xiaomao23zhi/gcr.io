FROM apache/airflow:2.2.5

RUN AIRFLOW_VERSION=2.2.5 && \
    PYTHON_VERSION="$(python --version | cut -d " " -f 2 | cut -d "." -f 1-2)" && \
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" && \
    pip install --no-cache-dir "apache-airflow[apache-livy,apache-spark,celery,http,jdbc,papermill,sftp]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
RUN pip install --no-cache-dir airflow-code-editor==5.2.2
