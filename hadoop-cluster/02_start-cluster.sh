#! /bin/sh

# default 3 nodes
N=${1:-3}

NET=datalake
NAMENODE=hadoop-namenode
NAMENODE_HOSTNAME=hadoop-namenode
DATANODE=hadoop-datanode
DATANODE_HOSTNAME=hadoop-datanode
IMAEG_NAME=khs920210/hadoop:1.0

# setup network
sudo docker network create --driver=bridge $NET

# start hadoop namenode
sudo docker rm -f $NAMENODE &> /dev/null
echo "start $NAMENODE container..."
sudo docker run -itd \
                --net=$NET \
                -p 50070:50070 \
                -p 8088:8088 \
                --name $NAMENODE \
                --hostname $NAMENODE_HOSTNAME \
                $IMAEG_NAME &> /dev/null


# start hadoop datanode
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f $DATANODE$i &> /dev/null
	echo "start $DATANODE$i container..."
	sudo docker run -itd \
	                --net=$NET \
	                --name $DATANODE$i \
	                --hostname $DATANODE_HOSTNAME$i \
	                $IMAEG_NAME &> /dev/null
	i=$(( $i + 1 ))
done 

# connect hadoop namenode container
sudo docker exec -it $NAMENODE bash