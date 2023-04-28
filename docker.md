# DockerFile
* ubuntu
```dockerfile
FROM ubuntu:latest
USER root
MAINTAINER xuechao 2829969299@qq.com
ENV PYTHONUNBUFFERED 1
ENV PATH=$PATH:/usr/node/bin
RUN mkdir /app /root/.pip
WORKDIR /app
RUN apt update && apt install -y language-pack-zh-hans tzdata --no-install-recommends
RUN rm -f /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt install -y gcc g++ swig wget unzip nginx git vim
RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
RUN wget --no-cache https://nodejs.org/dist/v14.17.4/node-v14.17.4-linux-x64.tar.xz
RUN tar -xvf node-v14.17.4-linux-x64.tar.xz && mv node-v14.17.4-linux-x64 /usr/node && rm -f node-v14.17.4-linux-x64.tar.xz
RUN wget --no-cache https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz && tar -xzvf Python-3.8.15.tgz
RUN cd Python-3.8.15 && ./configure prefix=/usr/local/python3 && make && make install
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
RUN tar -zxf ta-lib-0.4.0-src.tar.gz && cd ta-lib && ./configure --prefix=/usr && make && make install
RUN ln -s /usr/local/python3/bin/python3 /usr/bin/python && ln -s /usr/local/python3/bin/pip3 /usr/bin/pip
RUN echo "[global]\
    index-url = http://mirrors.aliyun.com/pypi/simple/ \
    [install] \
    trusted-host=mirrors.aliyun.com" > ~/.pip/pip.conf
RUN echo "export LC_ALL=zh_CN.UTF-8" >> ~/.bashrc
RUN echo "alias ll='ls -l'" >> ~/.bashrc
RUN pip install --upgrade pip Cython TA-Lib pandas
RUN mkdir /usr/local/lib/python3.8/
RUN ln -s /usr/lib/python3.8/lib-dynload/_bz2.cpython-38-x86_64-linux-gnu.so /usr/local/lib/python3.8/
RUN npm i yarn -g && npm i cnpm -g
COPY setup.py setup.py
COPY ctp.i ctp.i
RUN wget http://www.sfit.com.cn/DocumentDown/api_3/5_2_2/v6.6.9_traderapi_20220920.zip && unzip v6.6.9_traderapi_20220920.zip
RUN mv v6.6.9_traderapi_20220920/v6.6.9_20220914_api_linux64/v6.6.9_20220914_api/v6.6.9_20220914_20220914_api_traderapi_se_linux64 ctp
RUN mv ctp/thostmduserapi_se.so ctp/libthostmduserapi_se.so && mv ctp/thosttraderapi_se.so ctp/libthosttraderapi_se.so
RUN swig -python -py3 -c++ -threads -I./ctp -o ctp_wrap.cpp ctp.i && python setup.py install
RUN rm -rf /app && mkdir /app
CMD /bin/bash
```
* python
```dockerfile
FROM centos:latest
USER root
MAINTAINER xuechao 2829969299@qq.com
ENV PYTHONUNBUFFERED 1
ENV PATH=$PATH:/usr/node/bin
RUN mkdir /app
WORKDIR /app
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
RUN yum install -y langpacks-zh_CN && echo "LANG=zh_CN.utf8" > /etc/locale.conf
RUN yum install -y wget unzip cronie crontabs nginx openssl gcc automake autoconf libtool make mesa-libGL.x86_64
RUN yum install -y lsof openssh-server passwd openssl openssh-clients which python3.8 python38-devel rsync java git vim
RUN wget --no-cache https://nodejs.org/dist/v14.17.4/node-v14.17.4-linux-x64.tar.xz
RUN tar -xvf node-v14.17.4-linux-x64.tar.xz && mv node-v14.17.4-linux-x64 /usr/node && rm -f node-v14.17.4-linux-x64.tar.xz
RUN rm -f /usr/local/bin/pip && rm -f /usr/bin/pip
RUN ln -s /usr/bin/python3.8 /usr/bin/python && ln -s /usr/bin/pip3.8 /usr/bin/pip
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
RUN pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip Cython
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz
RUN tar -zxf ta-lib-0.4.0-src.tar.gz && cd ta-lib && ./configure --prefix=/usr && make && make install
RUN pip install TA-Lib && rm -rf ta-lib && rm -f ta-lib-0.4.0-src.tar.gz
RUN npm i yarn -g && npm i cnpm -g
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

### 使用本地构建
构建之前在命令行中输入以下两行就好：
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0
