#!/bin/bash

set -e

TAG="$DEPLOY_SERVER/$DEPLOY_NAMESPACE/$DEPLOY_IMAGE:latest"

echo -e "\033[1;36mLogging into registry...\033[0m"
echo $DEPLOY_TOKEN | docker login -u $DEPLOY_USER --password-stdin $DEPLOY_SERVER

echo -e "\033[1;36mBuilding docker image...\033[0m"
docker build -t $TAG .

echo -e "\033[1;36mPushing docker image...\033[0m"
docker push $TAG
