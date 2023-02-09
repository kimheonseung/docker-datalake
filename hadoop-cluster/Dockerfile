FROM ubuntu:22.10

LABEL name="KimHeonSeung"
LABEL version="1.0"
LABEL description="Hadoop Base"

WORKDIR /root

# dependencies
RUN apt-get update && apt-get install -y openssh-server openssh-client openjdk-8-jdk wget vim

# hadoop 3.1.4
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.4/hadoop-3.1.4.tar.gz && \
    tar -xzvf hadoop-3.1.4.tar.gz && \
    mv hadoop-3.1.4 /usr/local/hadoop && \
    rm hadoop-3.1.4.tar.gz
# COPY hadoop-3.1.4.tar.gz /root/
# RUN tar -xzvf hadoop-3.1.4.tar.gz && \
#     mv hadoop-3.1.4 /usr/local/hadoop && \
#     rm hadoop-3.1.4.tar.gz

# envs
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

RUN echo "HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc && \
    echo "PATH=\$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin" >> ~/.bashrc

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-dfs-yarn.sh ~/start-dfs-yarn.sh

RUN chmod +x $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    chmod +x ~/start-dfs-yarn.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]