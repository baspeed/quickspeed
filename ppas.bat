@echo off
SET THEFILE=quickspeed
echo Assembling %THEFILE%
c:\codetyphon\fpc\fpc64\bin\x86_64-win64\as.exe --64 -o I:\Proyectos\QuickSpeed\lib\x86_64-win64\QuickSpeed.o   I:\Proyectos\QuickSpeed\lib\x86_64-win64\QuickSpeed.s
if errorlevel 1 goto asmend
Del I:\Proyectos\QuickSpeed\lib\x86_64-win64\QuickSpeed.s
SET THEFILE=I:\Proyectos\QuickSpeed\QuickSpeed.exe
echo Linking %THEFILE%
c:\codetyphon\fpc\fpc64\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o I:\Proyectos\QuickSpeed\QuickSpeed.exe I:\Proyectos\QuickSpeed\link10552.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occurred while assembling %THEFILE%
goto end
:linkend
echo An error occurred while linking %THEFILE%
:end
