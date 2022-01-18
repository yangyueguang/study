# Docker
## 一、Docker的出现
技术的出现和进步源于需求的驱动
## 二、Docker安装
```bash
# Linux
curl -fsSL https://get.docker.com/ | sh
# daocloud.io 国内镜像
curl -sSL https://get.daocloud.io/docker | sh

# Red Hat -> Centos
yum install -y docker

# SUSE

# Debian -> Ubuntu
apt-get install -y docker
```
### 1.docker 权限问题
```bash
sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
```
### 2.docker 启动
```bash
systemctl start docker #启动
systemctl restart docker #重启
systemctl stop docker #停止
systemctl status docker #查看状态
systemctl enable docker #开机启动启动
systemctl disable docker #禁止自启动
service docker start
service docker stop
service docker restart
systemctl daemon-reload
systemctl restart docker.service
vi /etc/docker/daemon.json
```

## 三、Docker 基础用法
![https://img2018.cnblogs.com/blog/1491349/202002/1491349-20200207125305272-1620649644.png]


```bash
$ docker   # docker 命令帮助
 
Commands:
    attach    Attach to a running container                 # 当前 shell 下 attach 连接指定运行镜像
    build     Build an image from a Dockerfile              # 通过 Dockerfile 定制镜像
    commit    Create a new image from a container's changes # 提交当前容器为新的镜像
    cp        Copy files/folders from the containers filesystem to the host path
              # 从容器中拷贝指定文件或者目录到宿主机中
    create    Create a new container                        # 创建一个新的容器，同 run，但不启动容器
    diff      Inspect changes on a container's filesystem   # 查看 docker 容器变化
    events    Get real time events from the server          # 从 docker 服务获取容器实时事件
    exec      Run a command in an existing container        # 在已存在的容器上运行命令
    export    Stream the contents of a container as a tar archive   
              # 导出容器的内容流作为一个 tar 归档文件[对应 import ]
    history   Show the history of an image                  # 展示一个镜像形成历史
    images    List images                                   # 列出系统当前镜像
    import    Create a new filesystem image from the contents of a tarball  
              # 从tar包中的内容创建一个新的文件系统映像[对应 export]
    info      Display system-wide information               # 显示系统相关信息
    inspect   Return low-level information on a container   # 查看容器详细信息
    kill      Kill a running container                      # kill 指定 docker 容器
    load      Load an image from a tar archive              # 从一个 tar 包中加载一个镜像[对应 save]
    login     Register or Login to the docker registry server   
              # 注册或者登陆一个 docker 源服务器
    logout    Log out from a Docker registry server         # 从当前 Docker registry 退出
    logs      Fetch the logs of a container                 # 输出当前容器日志信息
    port      Lookup the public-facing port which is NAT-ed to PRIVATE_PORT
              # 查看映射端口对应的容器内部源端口
    pause     Pause all processes within a container        # 暂停容器
    ps        List containers                               # 列出容器列表
    pull      Pull an image or a repository from the docker registry server
              # 从docker镜像源服务器拉取指定镜像或者库镜像
    push      Push an image or a repository to the docker registry server
              # 推送指定镜像或者库镜像至docker源服务器
    restart   Restart a running container                   # 重启运行的容器
    rm        Remove one or more containers                 # 移除一个或者多个容器
    rmi       Remove one or more images                 
              # 移除一个或多个镜像[无容器使用该镜像才可删除，否则需删除相关容器才可继续或 -f 强制删除]
    run       Run a command in a new container
              # 创建一个新的容器并运行一个命令
    save      Save an image to a tar archive                # 保存一个镜像为一个 tar 包[对应 load]
    search    Search for an image on the Docker Hub         # 在 docker hub 中搜索镜像
    start     Start a stopped containers                    # 启动容器
    stop      Stop a running containers                     # 停止容器
    tag       Tag an image into a repository                # 给源中镜像打标签
    top       Lookup the running processes of a container   # 查看容器中运行的进程信息
    unpause   Unpause a paused container                    # 取消暂停容器
    version   Show the docker version information           # 查看 docker 版本号
    wait      Block until a container stops, then print its exit code   
              # 截取容器停止时的退出状态值
Run 'docker COMMAND --help' for more information on a command.
```

### docker
1. 在线安装指定版本
`curl https://releases.rancher.com/install-docker/18.06.sh | sh`
2. 安装docker-compose
```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
3. 安装容器可视化平台portainer
`docker pull portainer/portainer && docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer`
4. docker卸载
`sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux  docker-engine-selinux docker-engine`
5. 常用命令
```bash
docker run -d -p 8001:8000 -v /Users/supers/Downloads/root.log:/app/data/root.log --name some hub.docker.com/yangyueguang/flask:latest 
curl localhost:8001/api/list
```
```bash
systemctl start docker
systemctl enable docker
systemctl status docker
docker ps
docker image
docker rmi xxxxx
docker pull xxxxx
docker login hub.docker.com
docker push xxxxx
docker build -t nginx:latest .
docker run -itd --name abc -v ./data:/app/static -p 8080:8080 -e envirment=product nginx:latest
docker exec -it xxxx bash
docker container prune -f
docker logs xxxxx
docker image prune -a
docker history nginx:v2
```

## 四、构建自己的docker
```dockerfile
FROM centos:latest
USER root
MAINTAINER xuechao <2829969299@qq.com>
ENV PYTHONUNBUFFERED 1
ENV PATH=$PATH:/usr/node/bin
RUN mkdir /app
ONBUILD RUN echo 'start build'
WORKDIR /app
ADD . /app
COPY run.sh /app/
RUN yum install -y langpacks-zh_CN && echo "LANG=zh_CN.utf8" > /etc/locale.conf
RUN yum install -y wget unzip cronie crontabs python3 nginx openssl gcc automake autoconf libtool make mesa-libGL.x86_64
RUN wget --no-cache https://nodejs.org/dist/v14.17.4/node-v14.17.4-linux-x64.tar.xz
RUN tar -xvf node-v14.17.4-linux-x64.tar.xz && mv node-v14.17.4-linux-x64 /usr/node && rm -f node-v14.17.4-linux-x64.tar.xz
RUN pip3 install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip
RUN pip install Cython --install-option="--no-cython-compile"
RUN npm i yarn -g && npm i cnpm -g
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN echo "alias ll='ls -l'" >> ~/.bashrc
EXPOSE 8000 8085 8086
CMD python3 manager.py runserver 0.0.0.0:8000
ENTRYPOINT /app/run.sh
#ENTRYPOINT command param1 param2
```

## 五、推送镜像到自己的仓库
[https://hub.docker.com](https://hub.docker.com)
```bash
    docker login hub.docker.com -u xuechao -p $password
    docker tag $docker_name hub.docker.com/yangyueguang/test:latest
    docker push $image_path:$image_tag
    docker run -itd -p 5001:5001 --name=$image_name --restart=always -v /logs:/logs/logs $image_path:$image_tag
    docker stack deploy --with-registry-auth --prune -c docker-compose.yml monitor
```

## 六、docker编排
docker-compose.yml
```yaml
version: "3.5"
services:
  web:
    image: yangyueguang/flask:latest
    hostname: flask
    container_name: super
    user: root
    restart: always
    deploy:
      replicas: 2
    environment:
      - domain=abc.com
    ports:
      - 8001:8000
    volumes:
      - /Users/supers/Downloads/root.log:/app/data/root.log
    networks:
       - elk
  project.wsgi:
    image: yangyueguang/flask:latest
    command: bash -c "gunicorn -w 1 -k gevent -b 0.0.0.0:8085 projects.wsgi:application"
    expose:
      - "8085"
    ports:
      - 8085:8000
    environment:
      - host=196.196.196.87
      - DJANGO_SETTINGS_MODULE=projects.settings
    volumes:
      - /Users/supers/Downloads/root.log:/app/data/root.log

networks:
    elk:
        driver: bridge
```
docker-compose
```bash
docker-compose ps
docker-compose up -d
docker-compose down
docker-compose restart nginx
docker-compose logs nginx -f 100 -t
```

## 七、dockekr集群
```bash
docker stack deploy --with-registry-auth --prune -c ./docker-compose.yml stack_name
docker stack service ls
docker stack service logs nginx
docker stack config
docker stack restart nginx
docker stack rm nginx
docker swarm init
docker node ls
docker swarm join --token SWMTKN-1-03dn2trh2hlm5ypgg7ngmknfn9qaue92utlltbzrizzini011u-2z70ms05y0m9419hbntbba8ru 192.168.65.3:2377
docker swarm leave --force
num=`docker ps | grep nginx | wc -l`
while [[ $num -gt 0 ]]
do
echo "${num} containers are stopping, please wait!"
sleep 5
num=`docker ps | grep nlp | wc -l`
done
echo "All stopped"
```

## 八、kubernetes
k8s是为容器服务而生的一个可移植容器的编排管理工具，越来越多的公司正在拥抱k8s，
并且当前k8s已经主导了云业务流程，推动了微服务架构等热门技术的普及和落地，正在如火如荼的发展。
* 服务发现与调度
* 负载均衡
* 服务自愈
* 服务弹性扩容
* 横向扩容
* 存储卷挂载