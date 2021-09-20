#!/bin/bash

# Remove running containers
docker rm -f $(docker ps -qa)

# Make the network
docker network create trio-network

# Build images
docker build -t trio-task-flask:latest flask-app
docker build -t trio-task-db:latest db

# Run mysql container
docker run -d \
    --network trio-network \
    --name mysql \
    trio-task-db:latest

# Run flask app
docker run -d \
    --network trio-network \
    --name flask-app \
    trio-task-flask:latest

# Run nginx container
docker run -d \
    --network trio-network \
    --name nginx \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    -p 80:80 \
    nginx:alpine