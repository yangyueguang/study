#!/bin/bash
#export softwares=$(dirname $(pwd))"/softwares/"
export softwares=~/Desktop/softwares/
#while getopts d:i:h:f:o: option
#do
#  echo $option
#  echo #OPTARG
#done
#shift $((OPTIND-1))
#echo $*

# 库的名字
function xc() {
    case $1 in
        -v)
          print green 'xc version: 0.0.1';;
        -i|install)
          install $2;;
        -d|download)
          download $2;;
        -c|cmd)
          cmd $*;;
        save)
          if [[ $2 == -f ]]
          then
            save_image_from_file $3 $4
          elif [[ $2 == -i ]]
          then
            save_image $3 $4
          else
            print purple 'Usage: xc save [-f][-i] $file/$image $dir'
          fi
          ;;
        load)
          if [[ $2 == -f ]]
          then
            load_images_from_file $3
          elif [[ $2 == -d ]]
          then
            load_images_from_dir $3
          else
            print purple 'Usage: xc load [-f][-d] $file/$dir'
          fi
          ;;
        *)
          help;;
    esac
}

# 带颜色打印
function print() {
  front=2
  back=0
  case $1 in
    black)
      front=0;;
    red)
      front=1;;
    green)
      front=2;;
    yellow)
      front=3;;
    blue)
      front=4;;
    purple)
      front=5;;
    babyblue)
      front=6;;
    *)
      front=7;;
  esac
  echo -e "\033[3$front;4${back}m$2\033[0m"
  #0黑色。1红色。2绿色。3黄色。4蓝色。5紫色。6浅蓝色。7灰色。
}

# 安装软件
function install() {
  if [[ ! -d /data/ ]]
  then
    mkdir /data/
  fi
  case "$1" in
      git)
        install_git;;
      redis)
        install_redis;;
      redis-server)
        install_redis-server;;
      docker)
        install_docker;;
      docker-compose)
        install_docker-compose;;
      java)
        install_java;;
      es|elasticsearch)
        install_elasticsearch;;
      kibana)
        install_kibana;;
      local_yum)
        make_local_yaml;;
      *)
        print purple "Usage: xc install [git redis redis-server docker docker-compose java elasticsearch kibana local_yum]";;
  esac
}

# ''' ======================= 下面是内部调用的方法 ======================= '''
# execute a commond
function cmd() {
    case $2 in
      clear_memery)
        echo 3 > /proc/sys/vm/drop_caches;;
      deploy)
        if [[ $# -lt 4 ]]
        then
          print red 'Usage: xc cmd deploy $file $name'
        else
          docker stack deploy --with-registry-auth --prune -c $3 $4
        fi;;
      stop)
        if [[ $# -lt 4 ]]
        then
          print red 'Usage: xc cmd stop $name $keyword'
        else
          docker stack rm $3
          sc=1
          until [[ $sc -eq 0 ]]
          do
            sc=`docker ps | grep $4 | wc -l`
            echo "$sc containers are stopping, please wait!"
            sleep 3
          done
          echo "All stopped"
        fi;;
      *)
        print purple "Usage: xc cmd [clear_memery deploy stop]"
    esac
}

# pull image with $image
function pull_image() {
  image=$1
  image_name=${image##*/}
  isFind=`docker images|grep ${image_name/:*/}|wc -l`
  if [[ $isFind -gt 0 ]]
  then
    echo "已经下载过了: $1"
  else
    docker pull $1
  fi
}

# save docker image with $image $path
function save_image() {
  if [[ $# -lt 2 ]]
  then
    print red 'Usage: save_image $image $path'
  else
    image=$1
    pull_image $1
    image_name=${image##*/}
    image_dir=$2/
    if [[ ! -d $image_dir ]]
    then
      echo $image_dir | sed 's@//@/@g' | xargs -I {} mkdir -p {}
    fi
    docker save $1 | gzip > "$2/${image_name}.tgz"
  fi
}

# save docker image with $file
function save_image_from_file() {
  if [[ $# -lt 2 ]]
  then
    print red 'Usage: save_image_from_file $file $path'
  else
      file=$1
  for image in $(cat $1 | grep  hub.docker.com | grep -v "#" | awk -F  ": " '{print $2}')
  do
    pull_image $image
    image_name=${image##*/}
    docker save $image | gzip > "$2/${image_name}.tgz"
  done
  fi
}

# load images from yml file $file
function load_images_from_file() {
  file=$1
#  docker-compose $1 pull
  for image in $(cat $1 | grep  hub.docker.com | grep -v "#" | awk -F  ": " '{print $2}')
  do
    pull_image $image
  done
}

# load images from dir $dir
function load_images_from_dir() {
  current_path=`pwd`
  cd $1
  for file in `ls`
  do
    if [[ $file == *".tar.gz" ]]
    then
      tar -xzvf $file
      docker load -i ${file/.gz/}
    elif [[ $file == *".tar" || $file == *".tgz" ]]
    then
      docker load -i $file
    fi
  done
  cd $current_path
}

# is exist file in softwares $file
function isExist() {
  file=$softwares$1
  if [[ -f $file ]]
  then
    return 0
  else
    return 1
  fi
}

# 服务检查
function check() {
  local_ip=127.0.0.1
  es_port=9234
  java --version
  systemctl status docker
  ps aux | grep elasticsearch
  curl http://${local_ip}:${es_port}/_cat/health?v
  cd /data/redis-4.0.0/src/
  ./redis-cli -h $local_ip -p 6379
}

# 设置本地yum源
function make_local_yaml() {
    mkdir -p /media/centos7/
    mount $softwares/CentOS-7-x86_64-Everything-1908.iso /media/centos7/
    # 内网网络环境可以清空一下仓库信息
    mkdir repo.bak && mv /etc/yum.repos.d/*.repo repo.bak/
    # vim /etc/yum.repos.d/centos7-localsource.repo
    ######### 添加本地仓库 ############
    echo '[centos7-localsource]' >> /etc/yum.repos.d/centos7-localsource.repo
    echo 'name=centos7' >> /etc/yum.repos.d/centos7-localsource.repo
    echo 'baseurl=file:///media/centos7' >> /etc/yum.repos.d/centos7-localsource.repo
    echo 'enabled=1' >> /etc/yum.repos.d/centos7-localsource.repo
    echo 'gpgcheck=0' >> /etc/yum.repos.d/centos7-localsource.repo
    ###############################
    yum clean all
    yum makecache
}

# download resource from web with name $name
function download() {
   name=$1
   url=''
   case "$1" in
        git)
          url=https://github.com/git/git/archive/v2.20.1.zip;;
        redis)
          url=ftp://123.45.56.120:100/softwares/redis-4.0.0.tgz;;
        docker)
          url=ftp://123.45.56.120:100/softwares/docker-ce-17.09.tar.gz;;
        elasticsearch)
          url=ftp://123.45.56.120:100/softwares/elasticsearch-6.6.1.tgz;;
        java)
          url=ftp://123.45.56.120:100/softwares/jdk-8u211-linux-x64.rpm;;
        kibana)
          url=https://artifacts.elastic.co/downloads/kibana/kibana-6.3.2-linux-x86_64.tar.gz;;
        docker-compose)
          url="https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)";;
        local_yum)
          url="https://mirrors.aliyun.com/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1908.iso";;
        all)
          download git
          download redis
          download docker
          download elasticsearch
          download java
          download kibana
          download local_yum
          download docker-compose;;
        *)
          print purple "Usage: xc download [git redis docker docker-compose java elasticsearch kibana local_yum all]";;
    esac
    if [[ -n $url ]]
    then
      isExist ${url##*/}
      if [[ $? -eq 0 ]]
      then
        echo $softwares${url##*/}
        rm -rf $softwares${url##*/}
      fi
      wget $url -P $softwares --ftp-user=search_privatization --ftp-password=ea7caab05a5e
    fi
}

# ========================= install =========================
# install git with version $version
# shellcheck disable=SC2120
function install_git() {
  git --version
  if [[ $? -eq 0 ]]
  then
    echo "git install successed"
  else
    version=$1
    if [[ -z $1 ]]
    then
      version=2.20.1
    fi
    wget https://github.com/git/git/archive/v${version}.zip
    unzip v${version}.zip
    cd git-${version}
    make prefix=/usr/local/git all
    make prefix=/usr/local/git install
    whereis git
    echo 'export PATH=/usr/local/git/bin:$PATH' >> /etc/profile
    source /etc/profile
  fi
}

# install redis
function install_redis() {
    redis-cli -v
    if [[ $? -eq 0 ]]
    then
      echo "redis install successed"
    else
      isExist redis-stable.tar.gz
      if [[ $? -nq 0 ]]
      then
        curl -O http://download.redis.io/redis-stable.tar.gz
      fi
      mv redis-stable.tar.gz $softwares
      (
      cd $softwares
      tar -xzvf redis-stable.tar.gz
      cd redis-stable
      make
#      redis-server
      )
    fi
}

# install redis-server
install_redis-server(){
  read -p "Input redis host:" redis_ip
  read -p "Input redis port:" redis_port
  if [[ -f "/data/redis-4.0.0.tgz" ]];then
    rm -rf /data/redis-4.0.0.tgz
  fi
  cp ${softwares}/redis-4.0.0.tgz /data/
  cd /data/
  if [[ -d "/data/redis-4.0.0" ]];then
    rm -rf /data/redis-4.0.0
  fi
  ps aux | grep redis | grep -v "grep" | awk '{print $2}' | xargs kill -9
  tar -zxvf redis-4.0.0.tgz
  cd redis-4.0.0
  sed -i "s/bind 127.0.0.1/bind ${redis_ip}/" redis.conf
  sed -i "s/port 6379/port ${redis_port}/" redis.conf
  sed -i "s/databases 16/databases 64/" redis.conf
  sed -i 's/daemonize no/daemonize yes/' redis.conf
  su -l -c '/data/redis-4.0.0/src/redis-server /data/redis-4.0.0/redis.conf'
}

# install elasticsearch
install_elasticsearch(){
  cat /etc/security/limits.conf | grep -v "#" | while read line
  do
    sed -i "s/${line}/ /"  /etc/security/limits.conf
  done
  echo 'root soft memlock unlimited' >> /etc/security/limits.conf
  echo 'root hard memlock unlimited' >> /etc/security/limits.conf
  echo 'root soft nofile 65536' >> /etc/security/limits.conf
  echo 'root hard nofile 65536' >> /etc/security/limits.conf
  cat /etc/sysctl.conf | grep max_map_count | grep -v "#" | while read line
  do
    sed -i "s/${line}/ /"  /etc/sysctl.conf
  done
  echo 'vm.max_map_count=655360' > /etc/sysctl.conf
  sysctl -p
  # 关闭已有的可能启动的elasticsearch服务
  ps -aux | grep elasticsearch | grep -v "grep" | awk '{print $2}' | xargs kill -9
  if [[ -f "/data/elasticsearch-6.6.1.tgz" ]];then
    rm -rf /data/elasticsearch-6.6.1.tgz
  fi
  cp ${softwares}/elasticsearch-6.6.1.tgz /data/
  cd /data/
  if [[ -d "/data/elasticsearch-6.6.1" ]];then
    rm -rf /data/elasticsearch-6.6.1
  fi
  tar -zxvf elasticsearch-6.6.1.tgz
  cd elasticsearch-6.6.1/config
  # 需要交互输入，慎重
  read -p "Input elasticsearch ip:" es_ip
  read -p "Input elasticsearch port:" es_port
  read -p "Input jvm size (G) such as 32:" jvm_size
  sed -i "s/network.host: 192.168.0.1/network.host: $es_ip/" elasticsearch.yml
  sed -i "s/http.port: 9200/http.port: ${es_port}/" elasticsearch.yml
  sed -i "s/ping.unicast.hosts: \[.*\]/ping.unicast.hosts: \[\"$es_ip:9300\"\]/" elasticsearch.yml
  sed -i 's/minimum_master_nodes: 3/minimum_master_nodes: 1/' elasticsearch.yml
  sed -i "s/-Xms2g/-Xms${jvm_size}g/" jvm.options
  sed -i "s/-Xmx2g/-Xmx${jvm_size}g/" jvm.options
  su root -l -c '/data/elasticsearch-6.6.1/bin/elasticsearch -d'
  ps aux | grep elasticsearch
  es_url=http://${es_ip}:${es_port}
  echo "finished OK, use 'curl $es_url' and 'curl ${es_url}/_cat/health?v' to check"
}

# install docker
function install_docker() {
  cd $softwares
  tar -xzvf docker-ce-17.09.tar.gz
  cd docker-ce-17.09
  yum remove -y docker-engine
  mkdir -p /data/tmp
  chmod -R 777 /data/tmp
  mkdir -p /data/sys/var/docker
  chmod -R 777 /data/sys/var/docker
  ln -s /data/sys/var/docker /var/lib/docker
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  echo "vm.max_map_count=262144" > /etc/sysctl.conf && sysctl -p
  yum install -y net-softwares
  #  echo "duser:5VSDHai4" |chpasswd
  yum install -y policycoreutils-python
  rpm -ivh container-selinux-2.9-4.el7.noarch.rpm
  yum install -y ./docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm
  systemctl start docker
  systemctl enable docker
  systemctl status docker
}

# install java
function install_java() {
  mkdir /usr/java
  cp $softwares"jdk-8u211-linux-x64.rpm" /usr/java
  (
  cd /usr/java
  chmod +x jdk-8u211-linux-x64.rpm
  rpm -ivh jdk-8u211-linux-x64.rpm
  )
  java -version # 检查java是否安装成功，并且版本正确 java 1.8.0
}

# install docker-compose
function install_docker-compose() {
  isExist docker-compose.tar.gz
  if [[ $? -eq 0 ]]
  then
    (
    cd $softwares
    tar -xzvf docker-compose.tar.gz
    mv docker-compose /usr/local/bin/
    )
    chmod +x /usr/local/bin/docker-compose
    docker-compose --version
  else
    download docker-compose
    if [[ $? -eq 0 ]]
    then
      install_docker-compose
    fi
  fi
}

# install kibana
function install_kibana() {
    kibana -v
    if [[ $? -eq 0 ]]
    then
      echo 'kibana install successed'
    else
      isExist kibana-6.3.2-linux-x86_64.tar.gz
      if [[ $? -eq 0 ]]
      then
        tar -zxvf $softwares"kibana-6.3.2-linux-x86_64.tar.gz"
        echo 'server.port: 5601' >> config/kibana.yml
        echo 'server.host: "0.0.0.0"' >> config/kibana.yml
        echo 'elasticsearch.url: "http://192.168.2.18:9200"' >> config.kibana.yml
        echo 'kibana.index: ".kibana"' >> config.kibana.yml
        kibana-6.3.2-linux-x86_64/bin/kibana
      else
        download kibana
        if [[ $? -eq 0 ]]
        then
          install_kibana
        fi
      fi
    fi
}


function help() {
  # shellcheck disable=SC1042
  # shellcheck disable=SC1042
  desc=`cat << EOF
    Usage:	xc commond [options] [args]
    A custom function libary write by Super
    Options:
    .    -i  image: save image with image name
    .    -f  file: save or load images from docker-compose.yml
    .    -d  direction: load images from a direction
    .    -v  version Show the xc version information
    Commands:
    .    cmd         execute a commond
    .    download   download a project
    .    install    install a project
    .    save       save images from file or image
    .    load       load images from file or direction
    Run 'xc commond --help' for more information on a command.EOF`
  echo "$desc" | while read line; do
    print babyblue "$line"
  done
}
