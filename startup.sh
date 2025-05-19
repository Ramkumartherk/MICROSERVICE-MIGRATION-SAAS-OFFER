#!/bin/bash

# Update the package list
sudo apt-get update -y

# Install Docker
sudo apt-get install -y docker.io

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker



sudo docker pull ngdmapo/dmap_azure_blob_prod:latest

sudo docker run -d -it -p 5432:5432 -p 8080:8080 -p 5002:5002 -e UI_PORT=8080 -e SERVICE_PORT=5002 -e DB_PORT=5432 --name=dmap_db_prod_azure  ngdmapo/dmap_azure_blob_dev:latest

# app container

sudo docker run -d -it -p 8092:8080 -p 5005:5000 --name=dmap_app ngdmapo/dmap_app_migration_azure_blob_prod:latest