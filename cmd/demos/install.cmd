@echo off
copy /y all.bat %windir%\system32\>nul 2>nul
regedit /s 注册右键.reg
exit


