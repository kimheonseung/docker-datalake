#! /bin/sh

# default 3 nodes
N=${1:-3}

NET=datalake
NAMENODE=hadoop-namenode
NAMENODE_HOSTNAME=hadoop-namenode
DATANODE=hadoop-datanode
DATANODE_HOSTNAME=hadoop-datanode
IMAGE_NAME=khs920210/hadoop:1.0

PORT=8042
NODE_PORT=9864

HOSTNAME=localhost

# setup network
sudo docker network create --driver=bridge $NET

# start hadoop namenode
sudo docker rm -f $NAMENODE &> /dev/null
echo "start $NAMENODE container..."
sudo docker run -itd \
                --net=$NET \
                -p 9870:9870 \
                -p 8088:8088 \
								-p 9000:9000 \
                --name $NAMENODE \
                --hostname $HOSTNAME \
                $IMAGE_NAME &> /dev/null


# start hadoop datanode
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f $DATANODE$i &> /dev/null
	echo "start $DATANODE$i container..."
	sudo docker run -itd \
	                --net=$NET \
									-p $PORT:8042 \
									-p $NODE_PORT:9864 \
	                --name $DATANODE$i \
	                --hostname $HOSTNAME \
	                $IMAGE_NAME &> /dev/null
	i=$(( $i + 1 ))
	PORT=$(( $PORT + 1 ))
	NODE_PORT=$(( $NODE_PORT + 1 ))
done 

# connect hadoop namenode container
sudo docker exec -it $NAMENODE bash