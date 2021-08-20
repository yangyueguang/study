# 一、终端快捷键
快捷键 | 功能
--- | ---
Ctrl + a/Home |切换到命令行开始
Ctrl + e/End |切换到命令行末尾
Ctrl + l |清除屏幕内容，效果等同于 clear
Ctrl + u |清除剪切光标之前的内容
Ctrl + k |剪切清除光标之后的内容
Ctrl + y |粘贴刚才所删除的字符
Ctrl + r |在历史命令中查找 (这个非常好用，输入关键字就调出以前的命令了)
Ctrl + c |终止命令
ctrl + o |重复执行命令
Ctrl + d |退出 shell，logout
Ctrl + z |转入后台运行,但在当前用户退出后就会终止
Ctrl + t |颠倒光标所在处及其之前的字符位置，并将光标移动到下一个字符
Alt + t |交换当前与以前单词的位置
Alt + d |剪切光标之后的词
Ctrl+w |剪切光标所在处之前的一个词(以空格、标点等为分隔符)
Ctrl+(x u) |按住 Ctrl 的同时再先后按 x 和 u，撤销刚才的操作
Ctrl+s |锁住终端
Ctrl+q |解锁终端
!! |重复执行最后一条命令
history |显示你所有执行过的编号+历史命令。这个可以配合!编辑来执行某某命令
!$ |显示系统最近的一条参数
lsof -i:8000| 查看8000端口的服务
Shutdown Reboot Halt poweroff  | 关机和重启命令
uptime | 开机多久了

# 二、环境变量

环境变量|说明
---|---
PATH|决定了 shell 将到哪些目录中寻找命令或程序
HOME|当前用户主目录
MAIL|是指当前用户的邮件存放目录。
SHELL|是指当前用户用的是哪种 Shell。
HISTSIZE|是指保存历史命令记录的条数。
LOGNAME|是指当前用户的登录名。
HOSTNAME|是指主机的名称，许多应用程序如果要用到主机名的话，通常是从这个环境变量中来取得的。
LANG/LANGUGE|是和语言相关的环境变量，使用多种语言的用户可以修改此环境变量。
PS1|是基本提示符，对于 root 用户是#，对于普通用户是$。
PS2|是附属提示符，默认是“>”。可以通过修改此环境变量来修改当前的命令符，比如下列命令会将提示符修改成字符串“Hello,My NewPrompt :) ”。 # PS1=" Hello,My NewPrompt :) "
TERM | 未知
HISTCMD | 未知
HISTCONTROL | 未知
HISTIGNORE | 未知
HISTFILE | 未知
HISTFILESIZE | 未知
HISTSIZE | 未知
HISTTIMEFORMAT | 未知
 !! | 未知
 !$ | 未知
 !# | 未知
 !N | 未知
 !-N | 未知

# 三、语法
```bash
if [ "$a" = "root" ]
then
  command 
else
  command 
fi
for file in `ls`
do
  command 
done 
tags=(a b c)
for tag in ${tags[*]}
do
  command 
done 
cat a.conf | grep abc | while read line
do
    command 
done
while condition
do
    command
    # break ：跳出总循环
    # continue：跳出当前循环，继续下一次循环
done
until condition
do
    command
done
case 值 in
  模式1)
    command
    ;;
  模式2）
    command
    ;;
esac
```
## 四、表达式
* 1. 文件运算符

expression | description
--- | ---
-b file	|检测文件是否是块设备文件
-c file	|检测文件是否是字符设备文件
-d file	|检测文件是否是目录
-f file	|检测文件是否是普通文件（既不是目录，也不是设备文件）
-g file	|检测文件是否设置了 SGID 位
-k file	|检测文件是否设置了粘着位(Sticky Bit)
-p file	|检测文件是否是有名管道
-u file	|检测文件是否设置了 SUID 位
-r file	|检测文件是否可读
-w file	|检测文件是否可写
-x file |检测文件是否可执行
-s file	|检测文件是否为空（文件大小是否大于0)
-e file	|检测文件（包括目录）是否存在

* 2. 整数变量表达式

expression | description
--- | ---
if [ int1 -eq int2 ]  |  如果int1等于int2   
if [ int1 -ne int2 ]  |  如果不等于    
if [ int1 -ge int2 ]  |     如果>=
if [ int1 -gt int2 ]  |     如果>
if [ int1 -le int2 ]  |     如果<=
if [ int1 -lt int2 ]  |     如果<

* 3. 字符串变量表达式

expression | description
--- | ---
If  [ $a = $b ]              |   如果string1等于string2字符串允许使用赋值号做等号
if  [ $string1 !=  $string2 ]|   如果string1不等于string2       
if  [ -n $string  ]          |   如果string 非空(非0），返回0(true)  
if  [ -z $string  ]          |   如果string 为空
if  [ $sting ]               |   如果string 非空，返回0 (和-n类似)

* 4. 逻辑表达式

expression | description
--- | ---
if [ ! 表达式 ]   | 逻辑非
if [ 表达式1 –a 表达式2 ]| 逻辑与
if [ 表达式1 –o 表达式2 ]| 逻辑或

# 五、参数传递
获取参数值|含义
---|---
$0 | 文件的相对路径和文件名
basename $0| 文件的文件名
dirname $0|文件的相对路径
pwd| 当前路径
$(cd `dirname ${conf_path}` && pwd)/${conf_name}|当前文件绝对路径
$1 | 代表传入的第1个参数
$n | 代表传入的第n个参数
$# | 参数个数
$* | 以一个单字符串显示所有向脚本传递的参数。如"$*“用「”」括起来的情况、以"$1 $2 … $n"的形式输出所有参数
$@ | 与$*相同，但是使用时加引号，并在引号中返回每个参数。
$$ | 脚本运行的当前进程号
$！| 后台运行的最后一个进程的ID
$? | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
$* 与 $@ 的区别 | 只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 “1 2 3”（传递了一个参数），而 “@” 等价于 “1” “2” “3”（传递了三个参数）。

## 1. 参数自运算
`name=/dir1/dir2/dir3/my.file.txt`

表达式 |  说明
--- | ---
${name:1:4}          | 从第2个开始 往后截取4个字符
${#name}             | 输出为name的长度
${name#*/}           | 删掉第一个 / 及其左边的字符串：dir1/dir2/dir3/my.file.txt
${name##*/}          | 删掉最后一个 /  及其左边的字符串：my.file.txt
${name#*.}           | 删掉第一个 .  及其左边的字符串：file.txt
${name##*.}          | 删掉最后一个 .  及其左边的字符串：txt
${name%/*}           | 删掉最后一个  /  及其右边的字符串：/dir1/dir2/dir3
${name%%/*}          | 删掉第一个 /  及其右边的字符串：(空值)
${name%.*}           | 删掉最后一个  .  及其右边的字符串：/dir1/dir2/dir3/my.file
${name%%.*}          | 删掉第一个  .   及其右边的字符串：/dir1/dir2/dir3/my
${name/dir/path}     | 将第一个dir 替换为path：/path1/dir2/dir3/my.file.txt
${name//dir/path}    | 将全部dir 替换为 path：/path1/path2/path3/my.file.txt
${name-my.file.txt}  | 假如$file 沒有设定，则使用my.file.txt 作传回值。
${name:-my.file.txt} | 假如$file 沒有设定或为空值，則使用my.file.txt 作傳回值。
${name+my.file.txt}  | 假如$file 设为空值或非空值，均使用my.file.txt 作傳回值。
${name:+my.file.txt} | 若$file 为非空值，则使用my.file.txt 作傳回值。
${name=my.file.txt}  | 若$file 沒设定，则使用my.file.txt 作傳回值，同时將$file 賦值为my.file.txt
${name:=my.file.txt} | 若$file 沒设定或为空值，則使用my.file.txt 作传回值，同時將$file 賦值为my.file.txt
${name?my.file.txt}  | 若$file 沒设定，則將my.file.txt 輸出至STDERR
${name:?my.file.txt} | 若$file 没设定或为空值，则将my.file.txt 输出至STDERR
记忆的方法为：# 是 去掉左边（键盘上#在 $ 的左边） %是去掉右边（键盘上% 在$ 的右边） 单一符号是最小匹配；两个符号是最大匹配

## 2. 文件参数
测试方法:`sh xxx.sh -h 100 -ms abc && sh xxx.sh -t`
```bash
#!/bin/bash
while getopts h:ms option
do 
    case "$option" in
        h)
            echo "option:h, value $OPTARG"
            echo "next arg index:$OPTIND";;
        m)
            echo "option:m"
            echo "next arg index:$OPTIND";;
        s)
            echo "option:s"
            echo "next arg index:$OPTIND";;
        \?)
            echo "Usage: args [-h n] [-m] [-s]"
            echo "-h means hours"
            echo "-m means minutes"
            echo "-s means seconds"
            exit 1;;
    esac
done
shift $((OPTIND-1))
echo $*
echo "*** do something now ***"
```


# 六、命令
## 1. [awk](https://blog.csdn.net/u010502101/article/details/81839519)
变量 | 说明
---  | ---
ARGC       |          命令行参数个数
ARGV       |         命令行参数排列
ENVIRON    |        支持队列中系统环境变量的使用
FILENAME   |        awk浏览的文件名
FNR        |        浏览文件的记录数
FS         |        设置输入域分隔符，等价于命令行 -F选项
NF         |        浏览记录的域的个数
NR         |        已读的记录数
OFS        |        输出域分隔符
ORS        |        输出记录分隔符
RS         |        控制记录分隔符
$0         |变量是指整条记录。$1表示当前行的第一个域,$2表示当前行的第二个域,......以此类推。
$NF        | 是number 
finally    | 表示最后一列的信息，跟变量NF是有区别的，变量NF统计的是每行列的总数
BEGIN END  | function
```bash
cat /etc/passwd | awk -F: 'BEGIN{print "name, shell"} {print $1,$NF} END{print "hello  world"}'
awk '
function fshow(){
  printf "%-5s : %s\n", $1, $3
}
BEGIN{
  print "开始处理..."
}
{
  fshow()
}' file4
```

## 2. tail
参数| 说明
--- | ---
-f| 循环读取
-q| 不显示处理信息
-v| 显示详细的处理信息
-c<数目>| 显示的字节数
-n<行数>| 显示文件的尾部 n 行内容
--pid=PID| 与-f合用,表示在进程ID,PID死掉之后结束
-q, --quiet, --silent| 从不输出给出文件名的首部
-s, --sleep-interval=S| 与-f合用,表示在每次反复的间隔休眠S秒


## 3. iostat
- 用途:报告中央处理器(CPU)统计信息和整个系统、适配器、tty 设备、磁盘和 CD-ROM 的输入/ 输出统计信息。
- 语法:iostat [ -c | -d ] [ -k ] [ -t | -m ] [ -V ] [ -x [ device ] ] [ interval [ count ] ]
- 描述:iostat 命令用来监视系统输入/输出设备负载，这通过观察与它们的平均传送速率相关的物 理磁盘的活动时间来实现。
iostat 命令生成的报告可以用来更改系统配置来更好地平衡物理磁盘和适配 器之间的输入/输出负载。

参数 | 说明
--- | ---
-c| 为汇报 CPU 的使用情况;
-d| 为汇报磁盘的使用情况;
-k| 表示每秒按 kilobytes 字节显示数据; 
-m| 表示每秒按 M 字节显示数据;
-t| 为打印汇报的时间;
-v| 表示打印出版本信息和用法;
-x| device 指定 要统计的设备名称，默认为所有的设备;
interval| 指每次统计间隔的时间;
count| 指按照这个时间间隔统 计的次数。

## 4. sar
- sar [options] [-A] [-o file] t [n]
- 在命令行中，n 和 t 两个参数组合起来定义采样间隔和次数，t 为采样间隔，是必须有的参数，n 为采样次数，是可选的，默认值是 1，-o file 表示将命令结果以二进制格式存放在文件中，file 在此处 不是关键字，是文件名。options 为命令行选项，sar 命令的选项很多，下面只列出常用选项:

params|desc 
--- | ---
-A|所有报告的总和。
-u|CPU 利用率
-v|进程、I 节点、文件和锁表状态。 
-d|硬盘使用报告。 
-r|没有使用的内存页面和硬盘块。 
-g|串口 I/O 的情况。 
-b|缓冲区使用情况。 
-a|文件读写情况。 
-c|系统调用情况。 
-R|进程的活动情况。 
-y|终端设备活动情况。 
-w|系统交换活动。


## 5. 压缩打包
* linux 下的压缩命令有 tar、gzip、gunzip、bzip2、bunzip2、 compress、uncompress、zip、unzip、rar、 unrar 等等
* 压缩后的扩展名有.tar、.gz、.tar.gz、. tgz、.bz2、.tar.bz2、.Z、.tar.Z、.zip、.rar 10 种。

文件 | 命令
--- | ---
*.tar | tar –xvf 
*.gz | gzip -d 或者 gunzip 
*.tar.gz 和 *.tgz | tar –xzf 
*.bz2 | bzip2 -d 或者 bunzip2 
*.tar.bz2 | tar –xjf 
*.Z | uncompress 
*.tar.Z | tar –xZf 
*.rar | unrar e 
*.zip | unzip 

## 6. yum
```bash
yum -y install --downloadonly  --downloaddir=/tmp/  vlock
yum clean all
yum makecache
```

## 7. python
```bash
curl https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz -o python.tgz
yum install -y ncurses-libs zlib-devel mysql-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
pip3 freeze > require.txt  #
pip3 download -r require.txt -d packages
pip3 install --no-index -f packages -r require.txt
```

## 8. crontab
`* * * * * a.sh >> /app/root.log `
* 分 小时 日 月 周 具体的命令
* *表示任何时间 
* ,(逗号) 表示分隔时段的意思 5,10,15 * * * * weblogic 表示每个小时的5、10、15分的时候执行
* -（减号） 8点到12点的20分钟都运行 20 8-12 * * * weblogic 
* /n 表示每隔几分钟 */5 * * * * weblogic 
```bash
# 安装crontab
yum install vixie-cron
yum install crontabs
# 启动crontab服务
service crond start 启动服务
service crond stop 关闭服务
service crond restart 重启服务
service crond reload 重新载入配置
service crond status 服务状态
# 调度任务
crontab -l # 列出当前所有的调度任务
crontab -l -u test # 列出用户test的所有调度任务
crontab -r # 删除所有调度任务
crontab -e # 进行开始编写自己的定时代码
# 俩种执行方式
vim /etc/crontab # 编辑
vim test.cron # 注意不需要指定用户
# 添加任务
crontab test.cron
```

## 9. docker
1. 在线安装指定版本
`curl https://releases.rancher.com/install-docker/18.06.sh | sh`
2. 安装docker-compose
```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
3. 安装docker maching
```bash
base=https://github.com/docker/machine/releases/download/v0.16.0
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine
```
4. 安装容器可视化平台portainer
`docker pull portainer/portainer && docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer`
5. docker卸载
`sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux  docker-engine-selinux docker-engine`
6. 常用命令
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
docker-compose up -d
docker-compose down
docker-compose restart nginx
docker-compose logs nginx -f 100 -t
docker stack deploy --with-registry-auth --prune -c ./docker-compose.yml stack_name
docker stack service ls
docker stack service logs nginx
docker stack config
docker stack restart nginx
docker stack rm nginx
num=`docker ps | grep nginx | wc -l`
while [[ $num -gt 0 ]]
do
echo "${num} containers are stopping, please wait!"
sleep 5
num=`docker ps | grep nlp | wc -l`
done
echo "All stopped"
```

## 10. 其他
* node
* pip
* yarn
* npm & cnpm
* wget && wget -p
* xargs -I {} -t  -d  -n
* du -sh *
* df -h
* free -mh
* curl 
* cat
* watch -n 1 -d "uptime"
* ssh
* scp
* touch mv ls rm vi vim top which whoami whereis whatis pod find

# 七、使用技巧
### 1. 挂载nas目录：
```bash
export PASSWD=‘123456’
remote_ip=192.168.1.2
remote_dir=/data
remote_username=''
remote_password=$PASSWD
local_dir=/mydata
options=username=$remote_username,password=$remote_password,iocharset=utf8	
mount -t cifs -o $options //$remote_ip$remote_dir $local_dir
echo '//$remote_ip$remote_dir $local_dir cifs $options 0 0' >> /etc/fstab
```

### 2. 使用虚拟环境安装python3
```bash
pip install virtualenv 
virtualenv -h 
virtualenv -p /usr/bin/python3 py3env
source py3env/bin/activate  
pip install anything 
deactivate
```

### 3. 关闭防火墙及selinux
```shell
systemctl disable firewalld
systemctl stop firewalld
vi /etc/sysconfig/selinux
  SELINUX=disabled
setenforce 0
getenforce
```

### 4. 其他

功能 | 命令
--- | ---
查看系统信息| system_profiler SPNVMeDataType SPNetworkLocationDataType SPHardwareDataType
ssh 免密登录| ssh-copy-id remote_username@server_ip_address
当前用户 | id -nu
临时关闭SELinux | setenforce 0
临时打开SELinux | getenforce && setenforce 1
查看SELinux状态 | getenforce
开机关闭SELinux | 编辑/etc/selinux/config文件，将SELINUX的值设置为disabled
切换root用户    | sudo su
设置vim默认的配置|vim ~/.vimrc
清除buffer缓存|echo 3 > /proc/sys/vm/drop_caches  
后台运行| &
打洞 |ssh -fN root@ip:port -L localPort:ip:port
跳板机打洞 |ssh -fN -L local_port:dest_ip:dest_posrt -p jump_port jump_user@jump_server
通过跳板机传文件|scp -o "ProxyJump jump_user@jump_server:jump_port" local_dir dest_user@dest_id:dest_dir
通过跳板机传文件|ssh -t -p 10082 xiaoming@jumper.abc.com -fNL 51000:100.0.0.1:22 && scp -r -P 51000 /Users/xiaoming/test xiaoming@127.0.0.1:/tmp/
通过跳板机连接|ssh -J jump_user@jump_server:jump_port dest_user@dest_ip
临时设置 |alias cp='cp –i'
取消系统的别命令|unalias cp
永久生效 | 写入~/.bash_profile 或者~/.zshrc 或者 ～/.bashrc 然后 source ~/.bash_profile
数据增量同步类似于scp | rsync -avzP dir1 dir2
小括号是在新的进程中执行不影响现在的进程变量|(cd .. ; echo `pwd`);echo `pwd`
删除变量| unset name
监控服务器内存状态|vmstat 2
查看多核CPU运行情况|mpstat -P ALL

### 5. 案例
```bash
export current_path=`pwd`
read -p "Input redis host:" redis_ip
sed -i "s/bind 127.0.0.1/bind ${redis_ip}/" redis.conf
cat /etc/security/limits.conf | grep duser | grep -v "#" | while read line
do
    sed -i "s/${line}/ /"  /etc/security/limits.conf
done
cat a.txt|sort|unique|xargs -n 100 | zip| splite -m 500m - a.tar.gz
cat docker.md|grep -v "#"|awk -F ":" '/image/{print $2":"$3}'|uniq|awk '{split($1,a,"/"); print "docker save "$1"|gzip|> "a[3]".tar.gz"}'|xargs -I {} sh -c {}
sed '/searchtext/s/e.*o/aa/' a.txt # 包含查找和替换
su root -l -c 'echo abc' # 让root用户执行
apt-get install cmatrix # ubuntu下黑客帝国特效
apt-get install aview imagemagick # 命令行查看图片
颜色标识
printf  "\033[32m SUCCESS: yay \033[0m\n";
printf  "\033[33m WARNING: hmm \033[0m\n";
printf  "\033[31m ERROR: fubar \033[0m\n";
mysql -h host -P 000 -u root -p 123456  -e"use test_database; source data_faile; " # -e 代表执行sql语句
```

# 八、demo
```shell
#!/bin/bash
while getopts d:i:h:f:o: option
do
  echo $option
  echo #OPTARG
done
shift $((OPTIND-1))
echo $*

# 库的名字
function xc() {
    case $1 in
        -v)
          print green 'xc version: 0.0.1';;
        -i|install)
          print green install successed;;
        save)
          if [[ $2 == -f ]]
          then
            print green $3 $4
          elif [[ $2 == -i ]]
          then
            print green $3 $4
          else
            print purple 'Usage: xc save [-f][-i] $file/$image $dir'
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

function help() {
  desc=`cat << EOF
    Usage:	xc commond [options] [args]
    A custom function libary write by Super
    Options:
    .    -i  image: save image with image name
    .    -v  version Show the xc version information
    Commands:
    .    install    install a project
    .    save       save images from file or image
    Run 'xc commond --help' for more information on a command.EOF`
  echo "$desc" | while read line; do
    print babyblue "$line"
  done
}

```
