# DockerFile
* python
```dockerfile
FROM centos:latest
USER root
MAINTAINER xuechao <2829969299@qq.com>
ENV PYTHONUNBUFFERED 1
ENV PATH=$PATH:/usr/node/bin
RUN mkdir /app
WORKDIR /app
RUN yum install -y langpacks-zh_CN && echo "LANG=zh_CN.utf8" > /etc/locale.conf
RUN yum install -y wget unzip cronie crontabs python3 nginx openssl gcc automake autoconf libtool make
RUN wget --no-cache https://nodejs.org/dist/v14.17.4/node-v14.17.4-linux-x64.tar.xz
RUN tar -xvf node-v14.17.4-linux-x64.tar.xz && mv node-v14.17.4-linux-x64 /usr/node && rm -f node-v14.17.4-linux-x64.tar.xz
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN pip install Cython --install-option="--no-cython-compile"
RUN npm i yarn -g && npm i cnpm -g
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN echo "alias ll='ls -l'" >> ~/.bashrc
CMD /bin/bash
```

* vue
```dockerfile
FROM node:16 as node
ENV PYTHONUNBUFFERED 1
ENV TZ=Asia/Beijing
ENV PATH /app/node_modules/.bin:$PATH
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY script /app
WORKDIR /app
RUN npm install yarn -g
RUN npm install @vue/cli@3.7.0 -g
COPY package.json yarn.lock ./
RUN yarn install
RUN yarn run build:prd

FROM nginx as nginx
RUN mkdir /app
COPY --from=node /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx_config/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```


# docker-compose.yml
```yaml
version: "3.5"
services:
  web:
    image: xxxxxxxxxxxxx
    restart: always
    deploy:
      replicas: 1
    environment:
      - "domain=abc.com"
    ports:
      - 8080:8080
    volumes:
      - ./data:/app/data
```


# nginx.conf
``` bash
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /app;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
```

在项目根目录创建 .dockerignore 文件  
设置 .dockerignore 文件能防止 node_modules 和其他中间构建产物被复制到镜像中导致构建问题。  
**/node_modules  
**/dist
