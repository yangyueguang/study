:: author: Super
:: email: 2829969299@qq.com

@echo off
call :begin
call :admintest
call :vercheck
goto :menu

:begin
title Super 总结
color 0A
echo on
echo off
mode con: cols=50 lines=25
echo %date:~0,4%年%date:~5,2%月%date:~8,2%日%time:~0,2%时%time:~3,2%分%time:~6,2%秒
setlocal enabledelayedexpansion
set Line===================================================
cls

:admintest
title 测试是否是以管理员身份运行
set rnd=_%random%
md %windir%\%rnd% >nul 2>nul
if %errorlevel%==1 (
    echo.
    echo 请右键本文件，选择“以管理员身份运行”。
    echo.
    echo 您可以按任意键退出……
    pause>nul 2>nul
    exit)
rd /q %windir%\%rnd%
goto :EOF

:vercheck
title 系统版本检查
ver
ver | find "5.1" >nul 2>nul && (echo 您的当前系统是WinXP &goto :EOF)
ver | find "6.1" >nul 2>nul && (echo 您的当前系统是Win7 &goto :EOF)
ver | find "6.2" >nul 2>nul && (echo 您的当前系统是Win8 &goto :EOF)
ver | find "6.3" >nul 2>nul && (echo 您的当前系统是Win8.1 &goto :EOF)
ver | find "10.0" >nul 2>nul && (echo 您的当前系统是Win10.0 &goto :EOF)
echo.
goto :EOF

:menu
echo %Line%
echo.
echo		[A]	去除桌面箭头
echo		[B]	恢复桌面箭头
echo		[C]	关于
echo.
echo		[X]	退出
echo %Line%
choice /c ABCX /M 请选择
if %errorlevel%==1 call :remove_arror
if %errorlevel%==2 call :add_arror
if %errorlevel%==3 call :about
if %errorlevel%==4 exit
goto :menu

::   ===================================    关于    ===================================
:about
title 关于
echo.
echo Name:【Super 工具箱】
echo Author: Super
echo Wechat: 16621206049
echo Email: 2829969299@qq.com
echo Date: 2020年2月22日
echo.
goto :EOF

::  ==================================================================================================================

:remove_arror
title 去除桌面箭头
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /d "%systemroot%\system32\%value%" /t reg_sz /f
call :restart_explorer
goto :EOF

:add_arror
title 恢复桌面箭头
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v 29 /f
call :restart_explorer
goto :EOF

:restart_explorer
title 重启资源管理器
taskkill /f /im explorer.exe
start explorer
goto :EOF

:find_wifi
title 获取连接过的wifi密码
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do  @echo %i | findstr -i -v echo | netsh wlan show profiles %i key=clear >> "save.txt"
echo wifi密码已保存到save.txt中
goto :EOF

:replace_word
title 替换log文本文件字串
(for /f "delims=" %a in (R81_ros_home_btn_result.bat) do (
  set "str=%a"
  setlocal enabledelayedexpansion
  set "str=!str:原始文本=替换文本!"
  echo,!str!
  endlocal
))>"setup.tmp"
move /y "setup.tmp" "R81_ros_home_btn_result.bat"
goto :EOF

:find_u-disk
title 获取可移动磁盘的盘符
for %a in (c d e f g h i j k l m n o p q r s t u v w x y z) do (
    for /f %h in ('fsutil fsinfo drivetype %a:^|findstr "Removable.* 可移动"') do (
        set DriveU=%h
    )
)
echo %DriveU%
goto :EOF

:help
title cmd所有的命令需要手动执行代码
timeout 10
for %i in ( at cd if rd arp cls cmd del dir for net ver vol ren set rem
call chcp comp copy date  find goto mode mode path ping popd sort time tree type  exit echo wmic
assoc color ftype label mkdir pause print pushd rmdir shift start subst title xcopy erase
attrib chkdsk compact convert format prompt rename chkntfs netstat recover replace verify
certutil endlocal diskcomp diskcopy ipconfig tracert setlocal
) do (
echo %i
echo %i /?
)
goto :EOF

:wifi_on
title 打开wifi
netsh wlan set hostednetwork mode=allow ssid=Test key=0123456789
netsh wlan start hostednetwork
pause
goto :EOF

:wifi_off
title 关闭wifi
netsh wlan stop hostednetwork
netsh wlan set hostednetwork mode=disallow
pause
goto :EOF

:delete_all_Thumbs
title 删除所有的Thumbs.db
for /f "delims=\" %%i in ('fsutil fsinfo drives^|find /v ""') do (
    set var=%%i
    set drive=!var:~-2!
    fsutil fsinfo drivetype !drive!|find "固定">nul && del /a /f /s !drive!\Thumbs.db
)
goto :EOF

:delete_space_row
title 删除空行
set /p pathly=输入文件路径
set pathly="%pathly:"=%"        ::去掉变量中的引号
call :got_path_info %pathly%
for /f "usebackq tokens=* delims=" %i in ("%pathly%") do (
echo %i>>"%pathmb%临时文件.txt"
)
del /q /s "%pathly%"
ren "%pathmb%临时文件.txt" "%name%%type%"
goto :EOF

:got_path_info
set pathly="%~1"
set pathly=%pathly:&=^&%
set pathly=%pathly:|=^|%
set pathly=%pathly:"=%
set pathmb="%~dp1"
set pathmb=%pathmb:&=^&%
set pathmb=%pathmb:|=^|%
set pathmb=%pathmb:"=%
set name="%~n1"
set name=%name:&=^&%
set name=%name:|=^|%
set name=%name:"=%
set type="%~x1"
set type=%type:&=^&%
set type=%type:|=^|%
set type=%type:"=%
goto :eof

:rd_dir_empty
title 删除空目录
:: 最简洁的方案：先列出所有的目录之后，然后按照降序排列，删除。 关键在于要从最深层目录倒着删
REM for /f "tokens=*" %%a in ('dir /b /ad /s "目标路径"^|sort /r') do rd "%%a" 2>nul
rd %1 2>nul||goto :eof
set dir_route=%1
for /f "delims=" %%i in (%dir_route%) do (
    set dir_route="%%~dpi"
    for /f "delims=" %%j in ('dir /ad /b "%%~dpi"')do rd "%%~dpi%%j" 2>nul||goto :eof
)
:: 把路径最后的\去掉，以便set route_deepest="%%~dpi"能取到上一层路径
if "%dir_route:~-2,1%"=="\" set dir_route="%dir_route:~1,-2%"
if /i not "%cd%"==%dir_route% call :rd_dir_empty %dir_route%
goto :eof


:show_clock
title 时钟⏰
for %%a in (4 1 2 1 2 1 4 2 1 2 1 2 1 2 1 2 4 2 5 2 6 2 4 2 5 1 2
1 4 2 1 2 5 2 3 2 8 2 4 1 7 2 1 2 1 2 1 2 5 1 5 1 8 1 4 2 4) do (
  set/a "cc=~cc"
  for /l %%i in (1,1,%%a) do if "!cc!"=="0" (set "dgts=!dgts!　") else set "dgts=!dgts!■"
)
for /l %%z in () do (
        if "!time:~7,1!" neq "!sec!" (
                set "sec=!time:~7,1!"
                set "oc="
                for /l %%h in (0,1,4) do (
                        for %%d in (0 sp 1 sp : sp 3 sp 4 sp : sp 6 sp 7) do (
                                if "%%d"==":" (
                                        set/a tt=%%h*5
                                        if "!tt:~-1!"=="0" (set "oc=!oc!　") else set "oc=!oc!●"
                                ) else (
                                        if "%%d"=="sp" (set "oc=!oc!　") else (
                                                set "timeP=!time: =0!"
                                                set/a s=!timeP:~%%d,1!*15+%%h*3
                                                for %%o in (!s!) do set "oc=!oc!!dgts:~%%o,3!"
                                        )
                                )
                        )
                )
                cls
                set/p=!oc!<nul
        )
)
goto :EOF

:star_shine
title 颜色闪烁的文字
set a=☆☆☆☆☆☆☆☆☆☆
set b=★
set c=
set d=
set e=123456789abcde
echo/
echo **********(D--O--S)***********
echo  *Welcome to China Dos Union*
echo\
:b
for /l %%a in (0,1,9) do (
set /a f=%random%%%14+1
set/p=!a:~%%a,1!<nul&set/p=%b%<nul
ping -n 1 127.1>nul
color 0!e:~%f%,1!
set/p=%c%<nul
if %%a equ 9 (set/p=%d%<nul&for /l %%a in (9,-1,1) do (set/p=!a:~-%%a!!<nul&set/p=%b%<nul&ping -n 1 127.1>nul&set/p=%d%<nul))
)
goto b

:disk_info
title 显示磁盘分区信息
for /f "tokens=1,2 delims= " %%a in ('echo list disk ^|diskpart ^|findstr /r /c:"磁盘 [0-9] "') do (
        @echo select disk=%%b>%%b.script
        @echo list partition>>%%b.script
        @echo exit>>%%b.script
        rem 执行脚本,获取磁盘分区信息
        for /f "tokens=1,2 delims= " %%m in ('diskpart /s %%b.script ^|findstr /r /c:"分区 [0-9] "') do (
                rem 减去扩展的分区数
                set /a num=%%n-1
        )
        del %%b.script
        echo 磁盘 %%b        含有 !num! 个分区
)
pause
goto :EOF

:show_progress
title 进度条
set work=0&set n=0&set mo=0&set number=0&set all=60
:check
if %number% GTR %mo% set num=%num%▉ & set /a mo=%mo%+1 & goto check
cls
echo  进度： %n% / %all%   完成 %work% %%   剩余:(%all%-%n%)
echo.
if not "%num%"=="" echo %num%
if %n%==%all% goto :EOF
ping 127.1 -n 2 >nul
set /a n=%n%+1
set /a work=(%n%)*100 / (%all%)
set /a number=%work%/3+1
goto check

:show_auto_run_project
title 开机自启动的程序有：
for /f "skip=4 tokens=1* delims=:" %%i in ('reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run') do (
    set str=%%i
    set var=%%j
    set "var=!var:"=!"
    if not "!var:~-1!"=="=" echo !str:~-1!:!var!
)
goto :EOF

:type_word
title 打印字出现形式
set "col=123456789abcdef"
set /a n2=-1,over=15
set "str=枫中残雪：无心，无思，无情，无乡，无缘。没有失去，对我来说也没有珍惜。希望从何来，算了，还是不要明白好了。"
:start
set /a n=%random%%%14+1,n2+=1
if %over% equ %n% goto :start
if "!str:~%n2%,1!" neq "" (
>"!str:~%n2%,1!" set /p "= "<nul
findstr /a:0!col:~%n%,1! .* "!str:~%n2%,1!*"
ping /n 2 127.1>nul
del !str:~%n2%,1!
set "over=%n%"
)&&goto :start
goto :EOF

:display_dir
title 获取指定文件夹路径下的文件和文件夹列表
if "%~1"=="" (
    echo 请拖拽文件夹，到本文件图标上运行 或者给该函数传递参数
    goto :EOF
)
::for %%a in ("%~1") do echo %%a %%~na %%~xa
for %%a in ("%~1") do set dirname=%%~na%%~xa
tree /f "%~1" >"%dirname%.tree.txt"
dir /o:n /s /b "%~1" >"%dirname%.list.txt"
dir /o:n /s /q /t "%~1" >"%dirname%.dir.txt"
echo 文件和文件夹列表保存完成，请查看生成的txt文件
goto :EOF

:delete_right_menu
title "新建"菜单内容删除器
set input=
set /p input=   请输入后缀名：
if "%input%"=="" goto input
if "%input%"=="0" goto :eof
for /f %%i in ("%input%") do (reg delete HKCR\.%%i\ShellNew /f)
rem for /f %%i in ("%input%") do (reg delete HKCR\.%%i /f) ::force delete
goto :eof