#! /bin/sh
docker network create --driver=bridge datalake
docker-compose up -d
docker exec -it hadoop-namenode sh -c "/root/start-dfs-yarn.sh"