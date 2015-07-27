
FROM opadron/hadoop
MAINTAINER Omar Padron "omar.padron@kitware.com"

USER root

ENV SPARK_PREFIX /opt/spark
ENV SPARK_VERSION 1.4.1
ENV SPARK_URL_ROOT http://d3kbcqa49mib13.cloudfront.net
ENV SPARK_TAR_FILE spark-$SPARK_VERSION-bin-without-hadoop.tgz
ENV SPARK_DOWNLOAD_URL $SPARK_URL_ROOT/$SPARK_TAR_FILE

RUN wget $SPARK_DOWNLOAD_URL                                  && \
    tar -zxf $SPARK_TAR_FILE                                  && \
    rm $SPARK_TAR_FILE                                        && \
    mkdir -p "$( dirname "$SPARK_PREFIX" )"                   && \
    mv "$( basename "$SPARK_TAR_FILE" '.tgz' )" $SPARK_PREFIX && \
    mkdir -p $SPARK_PREFIX

ENV SPARK_CONF_DIR $SPARK_PREFIX/conf

ENV HADOOP_SHARE $HADOOP_PREFIX/share/hadoop
ENV SPARK_CLASSPATH \
$HADOOP_SHARE/yarn/*:\
$HADOOP_SHARE/yarn/lib/*:\
$HADOOP_SHARE/common/*:\
$HADOOP_SHARE/common/lib/*:\
$HADOOP_SHARE/hdfs/*:\
$HADOOP_SHARE/hdfs/lib/*:\
$HADOOP_SHARE/httpfs/tomcat/lib/*:\
$HADOOP_SHARE/kms/tomcat/lib/*:\
$HADOOP_SHARE/mapreduce/*:\
$HADOOP_SHARE/mapreduce/lib/*:\
$HADOOP_SHARE/mapreduce/lib-examples/*

ENV PATH $PATH:$SPARK_PREFIX/bin:$SPARK_PREFIX/sbin

ENV SPARK_HOME $SPARK_PREFIX
ENV PYTHONPATH \
$PYTHONPATH:\
$SPARK_HOME/python:\
$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip

COPY conf/spark-defaults.conf $SPARK_CONF_DIR/spark-defaults.conf

COPY scripts/run-sparkmaster /run-sparkmaster
COPY scripts/run-sparkslave  /run-sparkslave

ENV SPARK_MASTER spark://sparkmaster
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080

ENV SPARK_WORKER_PORT 3000
ENV SPARK_WORKER_WEBUI_PORT 8080

ENV SPARK_EXECUTOR_INSTANCES 4
ENV SPARK_EXECUTOR_CORES 1
ENV SPARK_EXECUTOR_MEMORY 500M

