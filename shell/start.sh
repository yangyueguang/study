#!/usr/bin/env bash
docker stack deploy --with-registry-auth --prune -c docker-compose.yml deploy_name
docker-compose up -d

yum -y install --downloadonly  --downloaddir=/tmp/  vlock

# 离线安装python及依赖
curl https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz -o python.tgz

1.安装pythyon相关依赖
yum install -y ncurses-libs zlib-devel mysql-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel

pip3 freeze > require.txt  #
pip3 download -r require.txt -d packages
pip3 install --no-index -f packages -r require.txt
cat docker-compose.yml|grep -v "#"|awk -F ":" '/image/{print $2":"$3}'|uniq|awk '{split($1,a,"/");print "docker save "$1"|gzip|> "a[3]".tar.gz"}'|xargs -I {} sh -c {}
# Spider settings
HTTPERROR_ALLOWED_CODES = [400,302]
SPIDER_NAME_ZIJI = {'PER_SPIDER_NAME':'None'}
COOKIES_ENABLED = True
COOKIES_DEBUG = True
REDIRECT_ENABLED = False

docker stack rm productnlpdemo
stopping_container=`docker ps | grep nlp | wc -l`
while [[ $stopping_container -gt 0 ]]
do
    echo "${stopping_container} containers are stopping, please wait!"
    sleep 5
    stopping_container=`docker ps | grep nlp | wc -l`
done
echo "All stopped"
