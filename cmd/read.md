# 批处理
## 命令说明
命令 | 说明
------------------  | ----------------
1. rem 和 ::         | 注释
2. echo 和 @         | 打印输出
3. pause            | 暂停
4. errorlevel       | 程序返回码$?
5. title            | 设置cmd窗口标题
6. color 0a         |0=黑色 8=灰色 1=蓝色 9=淡蓝色 2=绿色 A=淡绿色 3=湖蓝色 B=淡浅绿色 4=红色 C=淡红色 5=紫色 D=淡紫色 7=白色 F=亮白色
7. mode             | 配置系统设备  mode con cols=113 lines=15 & color 9f
8. goto 和 :         |goto XXX 跳转到标号:XXX处
9. find             |grep find [VCN] [/OFF[LINE]] "string" [path] /V -v /C 仅显示行数。/N 显示行号。/I 忽略大小写。
10. start           |调用外部命令程序如start explorer d:\
11. assoc 和 ftype   | assoc 设置'文件扩展名'关联 assoc .txt=txtfile   ftype exefile    ftype exefile="%1" %*
12. pushd 和 popd    | pushd c:\mp3 #保存当前目录，并切换当前目录为 c:\mp3 popd #恢复当前目录为刚才保存的 d:\mp4
13. call            |调用另一个批处理并传递参数 set aa=123456 set cmdstr=echo %aa%     call %cmdstr%
14. shift           | 更改批处理文件中可替换参数的位置
15. if              | IF exist autoexec.bat echo 文件存在! 
16. setlocal        |setlocal enabledelayedexpansion 启动变量延迟，变量立即变
17. attrib          |文件属性 attrib [+-][RASH] [path] [/S/D] +-R只读A存档S系统H隐藏/S -r /D也处理文件夹。attrib +a +s +h a.txt
18. del             | 删除rm
19. tree            | tree
20. copy move  rd mkdir   xcopy  ren=rename | commond

## 常用特殊符号
1. @ 命令行回显屏蔽符 
2. % 批处理变量引导符 
3. > 重定向符
4. >> 重定向符 
5. <、>&、<& 重定向符 
6. | 命令管道符
7. ^ 转义字符
8. & 组合命令 不管对错
9. && 组合命令 错了不执行后面的
10. || 组合命令 对了不执行后面的
11. "" 字符串界定符 
12. , 逗号当空格使用
13. ; 分号 dir c:\;d:\;e:\;z:\  以上命令相当于dir c:\ dir d:\  dir e:\  dir f:\
14. () 括号 
15. ! 感叹号 变量延迟问题中，用来表示变量，即%var%应该表示为!var!
16. type 理解为cat

## 系统变量
变量                 |    值             |   说明
-----               | ------            | -----
allusersprofile     |C:\ProgramData     |所有用户配置文件的位置
appdata             |C:\Users\Super\AppData\Roaming |返回默认情况下应用程序存储数据的位置
cd                  |C:\Users\Super     |返回当前目录字符串
cmdcmdline          |"C:\Windows\system32\cmd.exe"|cmd.exe程序地址
cmdextversion       |2                  |返回当前的“命令处理程序扩展”的版本号
computername        |DESKTOP-SNRSUSI    |系统返回计算机的名称
comspec             |C:\Windows\system32\cmd.exe|系统返回命令行解释器可执行程序的准确路径
date                |2020/04/02 周四     |返回当前日期
errorlevel          |0                  |系统返回上一条命令的错误代码
homedrive           |C:                 |系统返回连接到用户主目录的本地工作站驱动器号
homepath            |\Users\Super       |系统返回用户主目录的完整路径
homeshare           |%HOMESHARE%        |系统返回用户的共享主目录的网络路径
logonserver         |\\DESKTOP-SNRSUSI  |本地返回验证当前登录会话的域控制器的名称
number_of_processors|2                  |系统指定安装在计算机上的处理器的数目
os                  |Windows_NT         |系统返回操作系统名称
path                |C:\Windows\system32;C:\Windows;|指定可执行文件的搜索路径
pathext             |.COM;.EXE;.BAT;.CMD;.VBS;.JS|可执行的文件扩展名列表
processor_architecture|AMD64    |返回处理器的芯片体系结构值
processor_level     |6                  |系统返回计算机上安装的处理器的型号
processor_revision  |9e0a               |返回处理器的版本号
prompt              |$P$G               |当前解释程序的命令提示符
random              |8                  |0到32767之间的任意十进制数字
systemdrive         |C:                 |根目录(即系统根目录) 的驱动器
systemroot          |C:\Windows         |根目录的位置
temp 和 tmp          |C:\Users\SUPERS~1\AppData\Local\Temp|当前登录用户的默认临时目录
time                |14:38:37.33        |返回当前时间
userdomain          |DESKTOP-SNRSUSI    |返回包含用户帐户的域的名称
username            |Super              |返回当前登录的用户的名称
userprofile         |C:\Users\Super     |返回当前用户的配置文件的位置
windir              |C:\Windows         |返回操作系统目录的位置

## 常用语法
```bash
ver 
ipconfig /all
wmic logicaldisk get caption, freespace, size, description
显示文件夹下所有文件`dir /b /a /s`
可执行文件优先级.com>.exe>.bat>.cmd  
当只键入文件名时DOS执行的是name.com  
可执行文件用法:Bat2Com abc.bat，这样就会在同一目录下生成一个名为abc.com的可执行文件  
sleep延时的实现`echo 延时前:%time% ping /n 3 127.0.0.1 >nul echo 延时后:%time% pause`
timeout 30
dir /?
shutdown /r /t 50
文件夹变磁盘subst q: F:\桌面\RaySource
tasklist
if defined a echo %a%
:: /o:n 指的是按文件名升序排序
:: /b 是指不显示多余信息
dir /b /o:n > output.txt
@echo off
for /f "delims=" %%a in (the-file.txt) DO ( 
  ECHO Line is: %%a
)
以图形显示驱动器或路径的文件夹结构
TREE [drive:][path] [/F] [/A]
   /F   显示每个文件夹中文件的名称
   /A   使用ASCII字符而不使用扩展字符
VER 显示 Windows 版本

:find_wifi
title 获取连接过的wifi密码
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do  @echo %i | findstr -i -v echo | netsh wlan show profiles %i key=clear >> "save.txt"
echo wifi密码已保存到save.txt中
goto :EOF

REM echo %%i
REM echo 字节大小：%%~zi
REM echo 修改日期：%%~ti
REM echo 文件属性：%%~ai
REM echo 所在目录：%%~pi
REM echo 文件名称：%%~ni
REM echo 扩展名称：%%~xi
REM echo 完整路径：%%~fi
REM echo 驱动器号：%%~di
REM echo 文件短名：%%~si
REM echo.
@echo off
rem 开机自动运行
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v myrun /t REG_SZ /d "F:\工作\启动GBase服务.bat"
pause
打开文件或文件夹
start %cd%
删除文件
DEL /F /A /Q \\?\%1 
route print 列出本地机器当前的路由信息
netstat －an 查看本地机器的所有开放端口 
删除目录
RD /S /Q \\?\%1
弹出对话框
msg * 欢迎来到黑鹰安全网学习！www.3800hk.com

@echo off
echo 载入中，请稍后……
for /l %%i in (1,1,80) do set/p a=^><nul&ping /n 0 127.1>nul
pause

start http://www.3800hk.com
@echo off
taskkill /f /im Python.exe
pause
rem 用于关闭残留在后台进程的python进程
rem 创建vc6.0快捷方式以及Virtual Judge快捷方式
echo 创建快捷方式...
set path1=C:\Program Files\Microsoft Visual Studio\COMMON\MSDev98\Bin\MSDEV.EXE
set topath1="%USERPROFILE%/desktop/vc++6.0.url"
echo [InternetShortcut] >> %topath1%
echo URL="%path1%" >> %topath1%
echo IconIndex=0 >> %topath1%
echo IconFile=%path1% >> %topath1%
copy VirtualJudge.url Virtual_Judge.url
move Virtual_Judge.url %USERPROFILE%/desktop/
notepad C:\Windows\System32\drivers\etc\hosts
```
```bash
at 23:00 shutdown -s -f 
start winrar e */*.rar
@echo off
setlocal enabledelayedexpansion
echo ---------开机启动清单如下---------------
for /f  "skip=4 tokens=1* delims=:" %%i in ('reg query HKLM\SoftWare\Microsoft\Windows\CurrentVersion\Run') do (
set str=%%i
set var =%%j
set "var=!var:"=!"
if not "!var:~-1"=="=" echo !str:~-1:!var!
)
echo ---------开机启动清单如上---------------
pause > null
```
```bash
setlocal enabledelayedexpansion 
for /L %%i in (1 1 5) do (
set /a randomNum=!random!%%100
echo 随机数:!randomNum! )
pause
```
```bash
set var=我是值
set /p var=请输入变量的值
set /p input=请输入计算表达式: 
set /a var=%input%
set /a var = %var% + 1
echo 计算结果:%input%=%var%
```
```bash
%a:~0,n% 相当于a[,n]取左边n位
%a:~-m% 相当于a[-m,]
%a:~m,n% 相当于a[m+1,n]
%a:~m,-n% 相当于a[m+1,-n]
%a:~m % 相当于a[m+1,]
~I | %~fI|%~dI|%~pI|%~nI|%~xI
%~sI|%~aI|%~tI|%~zI|%~$PATH
%* 从第一个参数开始的所有参数
%0 文件自身
copy %0 d:\wind.bat
```

```bash
@echo off
if /i a == A echo 我们相等 else echo 我们不相等 pause
EQU - 等于
NEQ - 不等于 
LSS - 小于
LEQ - 小于或等于 
GTR - 大于
GEQ - 大于或等于
```
## 循环语句
1. 指定次数循环  
``` bash 
FOR /L %variable IN (start,step,end) DO command [command-parameters]
FOR /L %variable IN (start,step,end) DO ( Command1
Command2
......)
```
2. 对某集合执行循环语句  
```bash
FOR %%variable IN (set) DO command [command-parameters] %%variable
FOR /R [[drive:]path] %variable IN (set) DO command [command-parameters] 
FOR /R [[drive:]path] %variable IN (set) DO (Command1
Command2
......)
```
3. 条件循环  
```bash
@echo off
set var=0
rem ************循环开始了 
:continue
set /a var+=1
echo 第%var%次循环
if %var% lss 100 goto continue 
rem ************循环结束了 
echo 循环执行完毕
pause
```

## 子程序
```bash
@echo off
set sum=0
call :sub sum 10 20 35
echo 数据求和结果:%sum% 
pause
:sub
rem 参数 1 为返回变量名称 set /a %1=%1+%2
shift /2
if not "%2"=="" goto sub 
goto :eof
rem 运行结果:65
```

## 模拟进度条
```bash
@echo off
mode con cols=113 lines=15 &color 9f
cls
echo.
echo 程序正在初始化. . .
echo.
echo ┌──────────────────────────────────────┐
set/p= ■<nul
for /L %%i in (1 1 38) do set /p a=■<nul&ping /n 1 127.0.0.1>nul
echo 100%%
echo └──────────────────────────────────────┘
pause
```
解说:  
set /p a=■<nul的意思是:只显示提示信息'■'且不换行也不需手工输入任何信息这样可以使每个'■'在同一行逐个输出。  
ping /n 0 127.1>nul是输出每个'■'的时间间隔。  

```bash
@echo off
tasklist | find /i "qq.exe" && taskkill /f /im qq.exe || echo 你开了QQ?我不信
pause
```

## 设置环境变量
1、修改注册表的方法要重启才生效（永久的） 
`reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v path /d "%path%;C:\" /f`

2、使用WMIC，立即生效（永久的） 
`wmic ENVIRONMENT where "name='path' and username=''" set VariableValue='%path%;C:\'`
把C:\这个路径添加到path的变量中

3、要在批处理中立即生效（只是临时的，退出批处理后消失），P中加一句：
`path=%path%;C:\`

## 其他命令
### for
对一组文件中的每一个文件执行某个特定命令。
FOR %variable IN (set) DO command [command-parameters]
  %variable  指定一个单一字母可替换的参数。
  (set)      指定一个或一组文件。可以使用通配符。
  command    指定对每个文件执行的命令。
  command-parameters 为特定命令指定参数或命令行开关。

`FOR /D %variable IN (set) DO command [command-parameters]`  
`FOR /R [[drive:]path] %variable IN (set) DO command [command-parameters]`  
`FOR /L %variable IN (start,step,end) DO command [command-parameters]`  
`FOR /F ["options"] %variable IN (file-set) DO command [command-parameters]`  
`FOR /F ["options"] %variable IN ("string") DO command [command-parameters]`  
`FOR /F ["options"] %variable IN ('command') DO command [command-parameters]`  
`FOR /F ["options"] %variable IN (file-set) DO command [command-parameters]`  
`FOR /F ["options"] %variable IN ("string") DO command [command-parameters]`  
`FOR /F ["options"] %variable IN ('command') DO command [command-parameters]`  
"options" 这些关键字为:
        eol=c           - 指一个行注释字符的结尾(就一个)
        skip=n          - 指在文件开始时忽略的行数。
        delims=xxx      - 指分隔符集。这个替换了空格和跳格键的默认分隔符集。
        tokens=x,y,m-n  - 指每行的哪一个符号被传递到每个迭代的 for 本身。
        usebackq        - 指定新语法已在下类情况中使用:在作为命令执行一个后引号的字符串并且一个单引号字符为文字字符串命令  
`FOR /F "eol=; tokens=2,3* delims=, " %i in (myfile.txt) do @echo %i %j %k`  
`FOR /F "usebackq delims==" %i IN (`set`) DO @echo %i`  

     %~I         - 删除任何引号(")，扩展 %I
     %~fI        - 将 %I 扩展到一个完全合格的路径名
     %~dI        - 仅将 %I 扩展到一个驱动器号
     %~pI        - 仅将 %I 扩展到一个路径
     %~nI        - 仅将 %I 扩展到一个文件名
     %~xI        - 仅将 %I 扩展到一个文件扩展名
     %~sI        - 扩展的路径只含有短名
     %~aI        - 将 %I 扩展到文件的文件属性
     %~tI        - 将 %I 扩展到文件的日期/时间
     %~zI        - 将 %I 扩展到文件的大小
     %~$PATH:I   - 查找列在路径环境变量的目录，并将 %I 扩展到找到的第一个完全合格的名称

可以组合修饰符来得到多重结果:

     %~dpI       - 仅将 %I 扩展到一个驱动器号和路径
     %~nxI       - 仅将 %I 扩展到一个文件名和扩展名
     %~fsI       - 仅将 %I 扩展到一个带有短名的完整路径名
     %~dp$PATH:I - 搜索列在路径环境变量的目录，并将 %I 扩展
                   到找到的第一个驱动器号和路径。
     %~ftzaI     - 将 %I 扩展到类似输出线路的 DIR


### call
从批处理程序调用另一个批处理程序  
`CALL [drive:][path]filename [batch-parameters]`

### start
启动一个单独的窗口运行指定的程序或命令。

START ["title"] [/D path] [/I] [/MIN] [/MAX] [/SEPARATE | /SHARED]
      [/LOW | /NORMAL | /HIGH | /REALTIME | /ABOVENORMAL | /BELOWNORMAL]
      [/NODE <NUMA node>] [/AFFINITY <hex affinity mask>] [/WAIT] [/B]
      [command/program] [parameters]

### task
SCHTASKS /parameter [arguments]  
描述:允许管理员创建、删除、查询、更改、运行和中止本地或远程系统上的计划任务。  
参数列表:

    /Create         创建新计划任务。
    /Delete         删除计划任务。
    /Query          显示所有计划任务。
    /Change         更改计划任务属性。
    /Run            按需运行计划任务。
    /End            中止当前正在运行的计划任务。
    /ShowSid        显示与计划的任务名称相应的安全标识符。
    /?              显示帮助消息。

SCHTASKS /Create [/S system [/U username [/P [password]]]]
    [/RU username [/RP password]] /SC schedule [/MO modifier] [/D day]
    [/M months] [/I idletime] /TN taskname /TR taskrun [/ST starttime]
    [/RI interval] [ {/ET endtime | /DU duration} [/K] [/XML xmlfile] [/V1]]
    [/SD startdate] [/ED enddate] [/IT | /NP] [/Z] [/F]

    在远程机器 "ABC" 上创建计划任务 "doc",该机器每小时在 "runasuser" 用户下运行 notepad.exe。  
    SCHTASKS /Create /S ABC /U user /P password /RU runasuser /RP runaspassword /SC HOURLY /TN doc /TR notepad 
删除计划任务  
`SCHTASKS /Delete [/S system [/U username [/P [password]]]] /TN taskname [/F]`  
显示所有计划任务  
`SCHTASKS /Query [/S system [/U username [/P [password]]]] [/FO format | /XML [xml_type]] [/NH] [/V] [/TN taskname] [/?]`
