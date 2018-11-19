FROM ubuntu
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
RUN java -version
RUN mkdir /u01
COPY hadoop-2.9.1.tar.gz /u01
COPY apache-hive-2.3.3-bin.tar.gz /u01
WORKDIR /u01
RUN tar -zxf hadoop-2.9.1.tar.gz
RUN tar -zxf apache-hive-2.3.3-bin.tar.gz
RUN rm hadoop-2.9.1.tar.gz
RUN rm apache-hive-2.3.3-bin.tar.gz
RUN ln -s /u01/apache-hive-2.3.3-bin /usr/local/hive
RUN ln -s /u01/hadoop-2.9.1 /usr/local/hadoop
ENV HIVE_HOME /u01/apache-hive-2.3.3-bin
ENV HADOOP_HOME /u01/hadoop-2.9.1
#ADD hive-env.sh /usr/local/hive/conf/
ADD hive-config.sh /u01/apache-hive-2.3.3-bin/bin/
ENV PATH $PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin
RUN echo $PATH
RUN hive --version
RUN hdfs dfs -mkdir -p /user/hive/warehouse
RUN hdfs dfs -chmod g+w /tmp
RUN hdfs dfs -chmod g+w /user/hive/warehouse
#RUN $HIVE_HOME/bin/schematool -initSchema -dbType derby
ADD mysql-connector-java-8.0.11.jar $HIVE_HOME/lib
ADD hive-site.xml $HIVE_HOME/conf
EXPOSE 10000
CMD $HIVE_HOME/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false
