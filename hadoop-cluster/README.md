# Hadoop Cluster

### *<b>Build Image</b>*
```shell
# 01_build-image.sh
$ docker build -t $IMAGE_NAME .
```

### *<b>Create Network And Start Containers</b>*
```shell
# 02_start-cluster.sh

# default 3 nodes
N=${1:-3}

NET=datalake
NAMENODE=hadoop-namenode
NAMENODE_HOSTNAME=hadoop-namenode
DATANODE=hadoop-datanode
DATANODE_HOSTNAME=hadoop-datanode
IMAGE_NAME=khs920210/hadoop:1.0

PORT=8042

# setup network
sudo docker network create --driver=bridge $NET

# start hadoop namenode
sudo docker rm -f $NAMENODE &> /dev/null
echo "start $NAMENODE container..."
sudo docker run -itd \
                --net=$NET \
                -p 50070:50070 \
                -p 8088:8088 \
		-p $PORT:8042 \
		-p 9000:9000 \
                --name $NAMENODE \
                --hostname $NAMENODE_HOSTNAME \
                $IMAGE_NAME &> /dev/null


# start hadoop datanode
i=1
while [ $i -lt $N ]
do
	PORT=$(( $PORT + 1 ))
	sudo docker rm -f $DATANODE$i &> /dev/null
	echo "start $DATANODE$i container..."
	sudo docker run -itd \
	                --net=$NET \
			-p $PORT:8042 \
	                --name $DATANODE$i \
	                --hostname $DATANODE_HOSTNAME$i \
	                $IMAGE_NAME &> /dev/null
	i=$(( $i + 1 ))
done 

# connect hadoop namenode container
sudo docker exec -it $NAMENODE bash


# !! in container, you shoud run below once
./start-dfs-yarn.sh
```
