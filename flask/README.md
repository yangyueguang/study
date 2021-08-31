# Flask框架

#数据迁移
本框架弃用flask推荐的sqlalchemy，采用Django的orm，操作方便  
所以多写了两个Django的文件settings.py和manage.py用于数据迁移
```bash
python3 manage.py check
python3 manage.py makemigrations app
python3 manage.py migrate
```

如果使用的是sqlalchemy，则数据迁移方式如下
```bash
flask db init
flask db migrate
flask db upgrade
flask run -h 0.0.0.0 -p 8000 --reload
gunicorn run:app -c config.py
```
```bash
#!/bin/sh
image_path=yangyueguang/flask:$(date +%Y%m%d%H)
function build_docker() {
#  cp -r ~/.ssh ./
  #--no-cache 确保获取最新的外部依赖 -f 指定文件 ， -t 指定生成镜像名称
  docker build --no-cache -f docker/Dockerfile -t $image_path .
#  rm -rf ./.ssh
}

function push_docker() {
  docker push $image_path
}

function setup() {
  sudo python setup.py build_ext
}

function run() {
    cd app
    gunicorn run:app -c config.py
}
function start() {
  docker stack deploy --with-registry-auth --prune -c docker-compose.yml monitor
  sleep 5
  docker service ls | grep monitor
}

function stop() {
  docker stack rm monitor
  stopping_container=`docker ps | grep monitor | wc -l`
  while [[ $stopping_container -gt 0 ]]
  do
    echo "${stopping_container} containers are stopping, please wait!"
    sleep 5
    stopping_container=`docker ps | grep monitor | wc -l`
  done
  echo "All stopped"
}
```
docker-compose.yml
```yaml
version: '3'
services:
  logs_upload:
    image: yangyueguang/flask:2020042615
    restart: always
    ports:
      - 8000:5001
    volumes:
      - ./data/logs:/app/logs
    environment:
      - WORKERS=2
      - THREADS=2

```
