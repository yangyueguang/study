# Linux 学习笔记
## 终端快捷键:
```bash
Ctrl + a/Home 切换到命令行开始
Ctrl + e/End 切换到命令行末尾
Ctrl + l 清除屏幕内容，效果等同于 clear
Ctrl + u 清除剪切光标之前的内容
Ctrl + k 剪切清除光标之后的内容
Ctrl + y 粘贴刚才所删除的字符
Ctrl + r 在历史命令中查找 (这个非常好用，输入关键字就调出以前的命令了)
Ctrl + c 终止命令
ctrl + o 重复执行命令
Ctrl + d 退出 shell，logout
Ctrl + z 转入后台运行,但在当前用户退出后就会终止
Ctrl + t 颠倒光标所在处及其之前的字符位置，并将光标移动到下一个字符
Alt + t 交换当前与以前单词的位置
Alt + d 剪切光标之后的词
Ctrl+w 剪切光标所在处之前的一个词(以空格、标点等为分隔符)
Ctrl+(x u) 按住 Ctrl 的同时再先后按 x 和 u，撤销刚才的操作
Ctrl+s 锁住终端
Ctrl+q 解锁终端
!! 重复执行最后一条命令
history 显示你所有执行过的编号+历史命令。这个可以配合!编辑来执行某某命令
!$ 显示系统最近的一条参数
Shutdown Reboot Halt poweroff   关机和重启命令
uptime
vmstat 2
mpstat -P ALL
cat /proc/memeryinfo
iostat
用途:报告中央处理器(CPU)统计信息和整个系统、适配器、tty 设备、磁盘和 CD-ROM 的输入/ 输出统计信息。
语法:iostat [ -c | -d ] [ -k ] [ -t | -m ] [ -V ] [ -x [ device ] ] [ interval [ count ] ]
描述:iostat 命令用来监视系统输入/输出设备负载，这通过观察与它们的平均传送速率相关的物 理磁盘的活动时间来实现。
iostat 命令生成的报告可以用来更改系统配置来更好地平衡物理磁盘和适配 器之间的输入/输出负载。
参数:-c 为汇报 CPU 的使用情况;-d 为汇报磁盘的使用情况;-k 表示每秒按 kilobytes 字节显示数据; 
-m 表示每秒按 M 字节显示数据;-t 为打印汇报的时间;-v 表示打印出版本信息和用法;-x device 指定 要统计的设备名称，默认为所有的设备;
interval 指每次统计间隔的时间;count 指按照这个时间间隔统 计的次数。
lsof -i:8000 查看8000端口的服务
 
sar [options] [-A] [-o file] t [n]
在命令行中，n 和 t 两个参数组合起来定义采样间隔和次数，t 为采样间隔，是必须有的参数，n 为采样次数，是可选的，默认值是 1，-o file 表示将命令结果以二进制格式存放在文件中，file 在此处 不是关键字，是文件名。options 为命令行选项，sar 命令的选项很多，下面只列出常用选项:
-A:所有报告的总和。
-u:CPU 利用率
-v:进程、I 节点、文件和锁表状态。 -d:硬盘使用报告。 -r:没有使用的内存页面和硬盘块。 -g:串口 I/O 的情况。 -b:缓冲区使用情况。 -a:文件读写情况。 -c:系统调用情况。 -R:进程的活动情况。 -y:终端设备活动情况。 -w:系统交换活动。

注 5、常见的环境变量
PATH:决定了 shell 将到哪些目录中寻找命令或程序 HOME:当前用户主目录
MAIL:是指当前用户的邮件存放目录。 SHELL:是指当前用户用的是哪种 Shell。 HISTSIZE:是指保存历史命令记录的条数。 LOGNAME:是指当前用户的登录名。
HOSTNAME:是指主机的名称，许多应用程序如果要用到主机名的话，通常是从这个环境变量中来取得的。 LANG/LANGUGE:是和语言相关的环境变量，使用多种语言的用户可以修改此环境变量。 PS1:是基本提示符，对于 root 用户是#，对于普通用户是$。 PS2:是附属提示符，默认是“>”。可以通过修改此环境变量来修改当前的命令符，比如下列命令
会将提示符修改成字符串“Hello,My NewPrompt :) ”。 # PS1=" Hello,My NewPrompt :) "
```

十八、 压缩打包
```bash
linux 下的压缩命令有 tar、gzip、gunzip、bzip2、bunzip2、 compress、uncompress、zip、unzip、rar、 unrar 等等，压缩后的扩展名有.tar、.gz、.tar.gz、. tgz、.bz2、.tar.bz2、.Z、.tar.Z、.zip、.rar 10 种。
对应关系如下:
1、*.tar 用 tar –xvf 解压
2、*.gz 用 gzip -d 或者 gunzip 解压
3、*.tar.gz 和*.tgz 用 tar –xzf 解压
4、*.bz2 用 bzip2 -d 或者用 bunzip2 解压
5、*.tar.bz2 用 tar –xjf 解压
6、*.Z 用 uncompress 解压
7、*.tar.Z 用 tar –xZf 解压
8、*.rar 用 unrar e 解压
9、*.zip 用 unzip 解压
```

which
whereis
whatis
查看系统信息： system_profiler SPNVMeDataType SPNetworkLocationDataType SPHardwareDataType
ssh 免密登录：ssh-copy-id remote_username@server_ip_address
19 # 下边是另外一种判断root 用户的方法: 20
```bash
ROOTUSER_NAME=root
username=`id -nu`
if [ "$username" = "$ROOTUSER_NAME" ]
then
echo "Rooty, toot, toot. You are root."
else
echo "You are just a regular fella."
fi
tcsh% echo $LOGNAME bozo
tcsh% echo $SHELL /bin/tcsh
tcsh% echo $TERM rxvt
bash$ echo $LOGNAME bozo
bash$ echo $SHELL /bin/tcsh
bash$ echo $TERM rxvt
与Bash历史命令相关的内部变量: 
1. $HISTCMD
2. $HISTCONTROL
3. $HISTIGNORE
4. $HISTFILE
5. $HISTFILESIZE
6. $HISTSIZE
7. $HISTTIMEFORMAT (Bash 3.0或后续版本) 8. !!
9. !$
10. !#
11. !N
12. !-N
13. !STRING
14. !?STRING?
15. ^STRING^string^
```

## 表格 L-1. 批处理文件关键字 / 变量 / 操作符, 和等价的shell符号
批处理文件操作符|Shell脚本等价符号|含义
---|---|---
% |$ |命令行参数前缀
/|-|命令选项标记
\|/|目录路径分隔符
==|=|(等于)字符串比较测试
!==!|!= (不等)字符串比较测试
@|set +v|不打印当前命令
*|*|文件名"通配符"
｜|｜|管道
>|>|文件重定向(覆盖)
>>|>>|文件重定向(附加)
<|<|重定向stdin
%VAR%|$VAR|环境变量
REM|#|注释
NOT|!|取反
NUL|/dev/null|"黑洞"用来阻止命令输出
ECHO|echo|打印(Bash中有更多选项)
ECHO.|echo|打印空行
ECHO OFF|set +v|不打印后续的命令
FOR %%VAR IN (LIST)|DO for var in [list];do "for"|循环
:LABEL|没有等价物(多余)|标签
GOTO|没有等价物(使用函数)|跳转到脚本的另一个位置
PAUSE|sleep|暂停或等待一段时间
CHOICE|case or select|菜单选择
IF|if|if条件语句
IF EXIST FILENAME|if [ -e filename ] |测试文件是否存在
IF !%N==! |if [ -z "$N" ] |参数"N"是否存在
CALL|source命令或.(点操作符)|"include"另一个脚本
COMMAND /C|source命令或.(点操作符)|"include"另一个脚本(与CALL相同)
SET|export|设置一个环境变量
SHIFT|shift|左移命令行参数列表
SGN|-lt或-gt|(整形)符号
ERRORLEVEL|$?|退出状态
CON|stdin|"控制台"(stdin )
PRN|/dev/lp0|(一般的)打印设备
LPT1|/dev/lp0|第一个打印设备
COM1|/dev/ttyS0|第一个串口

## 表格 L-2. DOS命令与UNIX的等价命令
DOS命令| UNIX等价命令 |效果
---|---|---
ASSIGN|ln |链接文件或目录
ATTRIB|chmod| 修改文件权限
CD|cd| 更换目录
CHDIR|cd |更换目录
CLS|clear |清屏
COMP|diff, comm, cmp |文件比较
COPY|cp| 文件拷贝
Ctl-C|Ctl-C |中断(信号)
Ctl-Z|Ctl-D |EOF(文件结束)
DEL|rm| 删除文件
DELTREE |rm -rf| 递归删除目录
DIR|ls -l |列出目录内容
ERASE|rm |删除文件
EXIT|exit |退出当前进程
FC|comm, cmp |文件比较
FIND|grep| 在文件中查找字符串
MD|mkdir |新建目录
MKDIR|mkdir| 新建目录
MORE|more |分页显示文本文件
MOVE|mv |移动文件
PATH|$PATH |可执行文件的路径
REN|mv |重命名(移动)
RENAME|mv| 重命名(移动)
RD|rmdir |删除目录
RMDIR|rmdir| 删除目录
SORT|sort |排序文件
TIME|date |显示系统时间
TYPE|cat |将文件输出到stdout
XCOPY|cp |(扩展的)文件拷贝

# 挂载nas目录：
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

sudo apt-get install mongodb-10gen  # 安装

	$ sudo mkdir -p /data/db  # mongodb数据文件默认使用的文件夹
	$ sudo chmod -R 777 /data/db # 并递归设置文件的全部权限可用(不建议直接这么粗鲁)
	$ sudo service mongodb start
	$ sudo service mongodb stop
	$ sudo service mongodb restart
使用virtualenv安装python3

	$ pip install virtualenv # 安装第三方库
	$ virtualenv -h # 查看帮助
	$ virtualenv -p /usr/bin/python3 py3env #指定为python3,mac上也得先下载python3.dmg然后指定python3的路径
	$ source py3env/bin/activate  # 激活虚拟环境
	$ pip install anything # 在虚拟环境安装各种第三方库，还不需要sudo权限
	$ deactivate # 直到某时刻不再需要使用虚拟环境

```bash
https://blog.csdn.net/u010502101/article/details/81839519
ARGC               命令行参数个数
ARGV               命令行参数排列
ENVIRON            支持队列中系统环境变量的使用
FILENAME           awk浏览的文件名
FNR                浏览文件的记录数
FS                 设置输入域分隔符，等价于命令行 -F选项
NF                 浏览记录的域的个数
NR                 已读的记录数
OFS                输出域分隔符
ORS                输出记录分隔符
RS                 控制记录分隔符
$0变量是指整条记录。$1表示当前行的第一个域,$2表示当前行的第二个域,......以此类推。
1
$NF是number finally,表示最后一列的信息，跟变量NF是有区别的，变量NF统计的是每行列的总数
BEGIN
END
function
cat /etc/passwd | awk -F: 'BEGIN{print "name, shell"} {print $1,$NF} END{print "hello  world"}'
awk '
function fshow() 
{
    printf "%-5s : %s\n", $1, $3
}
BEGIN{
    print "开始处理..."
}
{
    fshow() 
}' file4
```


tail [参数] [文件]  
参数：

-f 循环读取
-q 不显示处理信息
-v 显示详细的处理信息
-c<数目> 显示的字节数
-n<行数> 显示文件的尾部 n 行内容
--pid=PID 与-f合用,表示在进程ID,PID死掉之后结束
-q, --quiet, --silent 从不输出给出文件名的首部
-s, --sleep-interval=S 与-f合用,表示在每次反复的间隔休眠S秒

通过跳板机传文件
```bash
ssh -t -p 10082 xiaoming@jumper.abc.com -fNL 51000:100.0.0.1:22 && scp -r -P 51000 /Users/xiaoming/test xiaoming@127.0.0.1:/tmp/

临时关闭SELinux
setenforce 0
临时打开SELinux
getenforce
setenforce 1
查看SELinux状态
getenforce
开机关闭SELinux
编辑/etc/selinux/config文件，如下图，将SELINUX的值设置为disabled。下次开机SELinux就不会启动了。
```
#### 一、配置网卡（无网环境忽略此条）

```shell
vi /etc/sysconfig/network-scripts/ifcfg-*
	BOOTPROTO=static	# 修改为静态网路，可以不修改
	ONBOOT=yes
systemctl restart network
```

#### 二、配置本地yum源（有网环境忽略此条）
```shell
mkdir /centos7		#存放本地yum源
mount /iso  ./tmp		#将iso镜像挂载到本地文件中
cp -vrf ./tmp/* /centos7	#将挂载后到本地文件copy到本地yum源文件中
cd /etc/yum.repos.d		
mv ./CentOS-*	/root/tmp	#移除yum到网络源信息
vi yum.repo		#编写本地yum
	[centos7-yum]
	name="yum.local"
	baseurl=file:///centos7
	gpgcheck=0
	enabled=1
yum clean all		#刷新缓存
rm -rf /var/cache/yum
yum list		#显示数据则表示本地yum配置成功
yum install net-tools	#安装net-tools，查看ifconfig
```

#### 三、关闭防火墙及selinux

```shell
systemctl disable firewalld
systemctl stop firewalld
vi /etc/sysconfig/selinux
	SELINUX=disabled
setenforce 0
getenforce
```
```bash
cat a.txt|sort|unique|xargs -n 100 | zip| splite -m 500m - a.tar.gz
docker卸载
$ sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux  docker-engine-selinux docker-engine

docker image prune
docker history nginx:v2
$ sudo curl -L https://github.com/docker/compose/releases/download/1.24.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose


mac制作centosU盘启动盘
mac下转换U盘格式为exfat
U盘拷贝4G以上文件时，某些格式无法支持，需要转换为exfat格式，mac下的格式转换比较方便，直接使用系统自带的磁盘工具，进行抹除操作的时候选择U盘格式为exfat即可，需要注意的是抹除的时候会格式化U盘，要提前备份U盘上的重要数据
centos无法识别exfat格式的硬盘
文件拷贝到U盘上后，问题来了，插到centos机器上系统直接报错，大意就是识别不了exfat格式的U盘，linux小白的我多亏万能的互联网，靠着各位大神指路搞定了，具体步骤如下
执行 sudo yum install fuse-exfat ，参考的博客里说可能会提示未找到安装包，我果然提示了
按照博客说明，需要添加rpmfusion源，下载地址为rpmfusion源文件下载地址，东西下载下来了，但并没有告诉小白怎么添加啊，继续百度查找到用sudo rpm -Uvh rpmfusion-free-release-7.noarch.rpm即可
进行步骤2的时候继续报错，我。。。。。看了下报错日志，大概意思是缺少了elpl，好吧，继续装，sudo yum install epel-release，然后运行步骤2，步骤1，终于顺利了
U盘插上，可以识别出来了，大功告成
mac下制作CentOS安装启动盘
使用diskutil list查看当前mac下挂载的硬盘目录
使用diskutil unmountDisk /dev/disk1取消移动硬盘的挂载，/dev/disk1是我自己电脑上移动硬盘挂载的路径
使用sudo dd if=~/Downloads/CentOS-7-x86_64-DVD-1708.iso of=/dev/rdisk1 bs=1m将centos的iso镜像刻录到移动硬盘上，在硬盘名disk1前加r传说会有提速的作用，因为运行dd的时候完全无法显示进度，就像进程死了一样。。。只能傻傻的等，查了一下使用kill结合指令可以临时显示进度，不过有dd进程无法继续运行的风险，dd完成后会有以下日志输出:
4312+0 records in
4312+0 records out
4521459712 bytes transferred in 1227.876111 secs (3682342 bytes/sec)
至此centos启动盘制作完毕

Linux 的 18 个装 B 命令，记得全部搂一遍！
1、sl 命令
你会看到一辆火车从屏幕右边开往左边
$ sudo apt-get install sl
运行
$ sl
cmatrix 命令
这个很酷！《黑客帝国》那种矩阵风格的动画效果
$ sudo apt-get install cmatrix
$cmatrix

figlet 命令
艺术字生成器，由ASCII字符组成，把文本显示成标题栏。此外还有banner这个命令
$sudo apt-get install figlet
figlet fuck

高大上仪表盘 blessed-contrib——假装自己指点江山，纵横捭阖
sudo apt-get install npm
sudo apt install nodejs-legacy
git clone https://github.com/yaronn/blessed-contrib.git
cd blessed-contrib
npm install
node ./examples/dashboard.js

图片转字符串
sudo apt-get install aview imagemagick
wget http://labfile.oss.aliyuncs.com/courses/1/Linus.png 
asciiview Linus.png

```

# 部署说明
```shell script
if [[ ! -d "images" ]]; then
if [[ $? -eq 0 ]]; then
other_images=(a b c)
for image in ${other_images[*]}
wget ftp://123.45.67.89:5000/l.bin -P ./data/model --ftp-user=username --ftp-password=123456
export project_path=`pwd`
read -p "Input redis host:" redis_ip
sed -i "s/bind 127.0.0.1/bind ${redis_ip}/" redis.conf
cat /etc/security/limits.conf | grep duser | grep -v "#" | while read line
do
    sed -i "s/${line}/ /"  /etc/security/limits.conf
done
sudo su 切换root用户
su duser -l -c 'exit'
if [[ -f "/data/duser/elasticsearch-6.6.1.tgz" ]];then
    rm -rf /data/duser/elasticsearch-6.6.1.tgz
fi
if [[-z  -n  -f  -d]]
xargs -I {} -t  -d  -n
vim ~/.vimrc    设置vim默认的配置
echo 3 > /proc/sys/vm/drop_caches  清除buffer缓存
$0: 文件的相对路径和文件名
basename $0: 文件的文件名
dirname $0:文件的相对路径
pwd: 当前路径
conf_path=$0
conf_name=`basename ${conf_path}`
abs_conf_path=$(cd `dirname ${conf_path}` && pwd)/${conf_name}
docker image prune
& : 后台运行
删除 所有未被容器使用的镜像：
docker image prune -a
删除 所有停止运行的容器：
docker container prune
打洞 ssh -fN root@ip:port -L localPort:ip:port
ssh -fN -L local_port:dest_ip:dest_posrt -p jump_port jump_user@jump_server
```
```
我的项目token：W5CTkd_nsgV2yc3zgnjv
通过跳板机传文件：scp -o "ProxyJump jump_user@jump_server:jump_port" local_dir dest_user@dest_id:dest_dir
通过跳板机连接：ssh -J jump_user@jump_server:jump_port dest_user@dest_ip
## 条件表达式
文件表达式
if [ -f  file ]    如果文件存在
if [ -d ...   ]    如果目录存在
if [ -s file  ]    如果文件存在且非空 
if [ -r file  ]    如果文件存在且可读
if [ -w file  ]    如果文件存在且可写
if [ -x file  ]    如果文件存在且可执行   
整数变量表达式
if [ int1 -eq int2 ]    如果int1等于int2   
if [ int1 -ne int2 ]    如果不等于    
if [ int1 -ge int2 ]       如果>=
if [ int1 -gt int2 ]       如果>
if [ int1 -le int2 ]       如果<=
if [ int1 -lt int2 ]       如果<
   字符串变量表达式
If  [ $a = $b ]                 如果string1等于string2字符串允许使用赋值号做等号
if  [ $string1 !=  $string2 ]   如果string1不等于string2       
if  [ -n $string  ]             如果string 非空(非0），返回0(true)  
if  [ -z $string  ]             如果string 为空
if  [ $sting ]                  如果string 非空，返回0 (和-n类似) 
   逻辑非 !                   条件表达式的相反
if [ ! 表达式 ]
if [ ! -d $num ]                        如果不存在目录$num
    逻辑与 –a                    条件表达式的并列
if [ 表达式1  –a  表达式2 ]
    逻辑或 -o                    条件表达式的或
if [ 表达式1  –o 表达式2 ]
临时设置 alias cp='cp –i'
取消系统的别命令unalias cp      
永久生效
~/.bash_profile 这是shell脚本的全局变量，可以把一直用的东西放在这里。
vi ~/.bash_profile        
alias cp='cp -i'
source ~/.bash_profile
数据增量同步，类似于scp
rsync -avzP dir1 dir2
echo ${x/a/b} 替换
%echo ${x//a/b} # 将所有a替换为b
小括号是在新的进程中执行，不影响现在的进程变量，如：(cd .. ; echo `pwd`);echo `pwd`
echo ${name:1:4} #输出 is i1:4 从第2个开始 往后截取4个字符
删除变量： unset name;  （删除之后不可访问，删除不掉只读变量）
在${}中使用“#”获取长度
name=“test”;
echo ${#name}; # 输出为4
参数传递
获取参数值： 
$0 ： 固定，代表执行的文件名
$1 ： 代表传入的第1个参数
$n ： 代表传入的第n个参数
$#：参数个数
$*： 以一个单字符串显示所有向脚本传递的参数。如"$*“用「”」括起来的情况、以"$1 $2 … $n"的形式输出所有参数
$@：与$*相同，但是使用时加引号，并在引号中返回每个参数。
$$：脚本运行的当前进程号
$！：后台运行的最后一个进程的ID
$?： 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
$* 与 $@ 区别 
相同点：都是引用所有参数。
不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 “1 2 3”（传递了一个参数），而 “@” 等价于 “1” “2” “3”（传递了三个参数）。
```

``` shell script
文件运算符

-b file	：检测文件是否是块设备文件，如果是，则返回 true。	[ -b $file ] 返回 false。
-c file	：检测文件是否是字符设备文件，如果是，则返回 true。	[ -c $file ] 返回 false。
-d file	：检测文件是否是目录，如果是，则返回 true。	[ -d $file ] 返回 false。
-f file	：检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。	[ -f $file ] 返回 true。
-g file	：检测文件是否设置了 SGID 位，如果是，则返回 true。	[ -g $file ] 返回 false。
-k file	：检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。	[ -k $file ] 返回 false。
-p file	：检测文件是否是有名管道，如果是，则返回 true。	[ -p $file ] 返回 false。
-u file	：检测文件是否设置了 SUID 位，如果是，则返回 true。	[ -u $file ] 返回 false。
-r file	：检测文件是否可读，如果是，则返回 true。	[ -r $file ] 返回 true。
-w file	：检测文件是否可写，如果是，则返回 true。	[ -w $file ] 返回 true。
-x file ：检测文件是否可执行，如果是，则返回 true。	[ -x $file ] 返回 true。
-s file	：检测文件是否为空（文件大小是否大于0），不为空返回 true。	[ -s $file ] 返回 true。
-e file	：检测文件（包括目录）是否存在，如果是，则返回 true。	[ -e $file ] 返回 true。


while condition
do
    command
done
until condition
do
    command
done

case 值 in
  模式1)
    command1
    command2
    ...
    commandN
    ;;
  模式2）
    command1
    command2
    ...
    commandN
    ;;
esac

break ：跳出总循环
continue：跳出当前循环，继续下一次循环

颜色标识
printf  "\033[32m SUCCESS: yay \033[0m\n";
printf  "\033[33m WARNING: hmm \033[0m\n";
printf  "\033[31m ERROR: fubar \033[0m\n";


 /mysql/mysql/bin/mysql \
  -h test_host  -P 000 \
  -u test_user -ptest_password \
  -e"use test_database; source data_faile; " # -e 代表执行sql语句


介绍下Shell中的${}、##和%%使用范例，本文给出了不同情况下得到的结果。
假设定义了一个变量为：
代码如下:
file=/dir1/dir2/dir3/my.file.txt
可以用${ }分别替换得到不同的值：
${file#*/}：删掉第一个 / 及其左边的字符串：dir1/dir2/dir3/my.file.txt
${file##*/}：删掉最后一个 /  及其左边的字符串：my.file.txt
${file#*.}：删掉第一个 .  及其左边的字符串：file.txt
${file##*.}：删掉最后一个 .  及其左边的字符串：txt
${file%/*}：删掉最后一个  /  及其右边的字符串：/dir1/dir2/dir3
${file%%/*}：删掉第一个 /  及其右边的字符串：(空值)
${file%.*}：删掉最后一个  .  及其右边的字符串：/dir1/dir2/dir3/my.file
${file%%.*}：删掉第一个  .   及其右边的字符串：/dir1/dir2/dir3/my
记忆的方法为：
# 是 去掉左边（键盘上#在 $ 的左边）
%是去掉右边（键盘上% 在$ 的右边）
单一符号是最小匹配；两个符号是最大匹配
${file:0:5}：提取最左边的 5 个字节：/dir1
${file:5:5}：提取第 5 个字节右边的连续5个字节：/dir2
也可以对变量值里的字符串作替换：
${file/dir/path}：将第一个dir 替换为path：/path1/dir2/dir3/my.file.txt
${file//dir/path}：将全部dir 替换为 path：/path1/path2/path3/my.file.txt

利用${ } 还可针对不同的变数状态赋值(沒设定、空值、非空值)： 
${file-my.file.txt} ：假如$file 沒有设定，則使用my.file.txt 作传回值。(空值及非空值時不作处理) 
${file:-my.file.txt} ：假如$file 沒有設定或為空值，則使用my.file.txt 作傳回值。(非空值時不作处理)
${file+my.file.txt} ：假如$file 設為空值或非空值，均使用my.file.txt 作傳回值。(沒設定時不作处理)
${file:+my.file.txt} ：若$file 為非空值，則使用my.file.txt 作傳回值。(沒設定及空值時不作处理)
${file=my.file.txt} ：若$file 沒設定，則使用my.file.txt 作傳回值，同時將$file 賦值為my.file.txt 。(空值及非空值時不作处理)
${file:=my.file.txt} ：若$file 沒設定或為空值，則使用my.file.txt 作傳回值，同時將$file 賦值為my.file.txt 。(非空值時不作处理)
${file?my.file.txt} ：若$file 沒設定，則將my.file.txt 輸出至STDERR。(空值及非空值時不作处理)
${file:?my.file.txt} ：若$file 没设定或为空值，则将my.file.txt 输出至STDERR。(非空值時不作处理)
function add() {
	echo $0
}
add abc


crontab
命令crontab -e进行开始编写自己的定时代码
* * * * * /u01/app/test/bak/bin/bak.sh >> /u01/app/test/bak/log/bak.log
分 小时 日 月 周 具体的命令

特殊符号：
表示任何时间 如果代码中日月周都是*表示任何时候的这个点都会执行
,(逗号) 表示分隔时段的意思 5,10,15 * * * * weblogic /u01/app/test/bak/bin/bak.sh >> /u01/app/test/bak/log/bak.log表示每个小时的5分 十分15分的时候执行（每小时执行三次）
-（减号） 8点到12点的 20分钟都运行 20 8-12 * * * weblogic /u01/app/test/bak/bin/bak.sh >> /u01/app/test/bak/log/bak.log
/n 表示每隔几分钟 */5 * * * * weblogic /u01/app/test/bak/bin/bak.sh >> /u01/app/test/bak/log/bak.log
注意周和日月不能同时使用
1.安装crontab
yum install vixie-cron
yum install crontabs
2.启动crontab服务
service crond start 启动服务
service crond stop 关闭服务
service crond restart 重启服务
service crond reload 重新载入配置
service crond status 服务状态
3.调度任务
crontab -l 列出当前所有的调度任务
crontab -l -u test 列出用户test的所有调度任务
crontab -r 删除所有调度任务
4.俩种执行方式
4.1 vim /etc/crontab 编辑
4.2 vim test.cron  注意不需要指定用户
添加任务 crontab test.cron
在线安装指定版本的docker
curl https://releases.rancher.com/install-docker/18.06.sh | sh
安装容器可视化平台portainer
docker pull portainer/portainer && docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer


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

```
test:
sh xxx.sh -h 100 -ms abc
sh xxx.sh -t
安装docker maching
base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine
# 包含查找和替换
sed '/searchtext/s/e.*o/aa/' a.sh 
```
