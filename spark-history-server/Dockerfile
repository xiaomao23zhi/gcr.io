ARG SPARK_IMAGE=gcr.io/spark-operator/spark:v3.1.1
FROM ${SPARK_IMAGE}

COPY entrypoint.sh /usr/bin/

ENTRYPOINT ["/opt/entrypoint.sh"]
