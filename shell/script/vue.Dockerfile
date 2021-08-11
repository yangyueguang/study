FROM node:14.17.4 as node
WORKDIR /app
COPY . /app
ENV PATH /app/node_modules/.bin:$PATH
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



#在项目根目录创建 .dockerignore 文件
#设置 .dockerignore 文件能防止 node_modules 和其他中间构建产物被复制到镜像中导致构建问题。
#**/node_modules
#**/dist

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
