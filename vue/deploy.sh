#!/bin/bash
image_url=yangyueguang/vue:20200808

sudo docker build --build-arg https_proxy="${https_proxy}" -t $image_url .
sudo docker push $image_url

docker-compose up -d
