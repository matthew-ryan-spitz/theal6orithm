## Docker Commands

docker rm ..
-- automatically remove the container when it exists
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -qf dangling=true)
-- clean up environment

docker ps
-- lists running docker containers
-- a flag, lists all docker containers

docker images
-- lists docker images

docker build -t service:v1 .
docker run -it service:v1
-- builds & runs python impage

pip list
-- checks pip packages installed within container(e.g. wheel: 0.42.0)

docker-compose up -d
-- builds images [if not built] & runs containers in docker-composer yaml file
docker-compose up -d --build service1 --build service2
-- explicit direction to build images

docker-compose down
-- shuts down containers

docker logs
-- checks logs of containers to find potential errors

docker pull mageai/mageai:latest
-- to update mage image