@echo off
setlocal
set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "TP=%ROOT%\third_party\ffmpeg"
set "BUILD=%ROOT%\build"
set "DIST=%ROOT%\dist"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSPATH=%%i"
call "%VSPATH%\VC\Auxiliary\Build\vcvars32.bat" >nul
cl /nologo /W3 /O2 /MT /EHsc /wd4819 /utf-8 /I"%TP%\include" /Fo"%BUILD%\\" /Fe"%DIST%\decode_probe.exe" "%ROOT%\tools\decode_probe.cpp" ^
   "%TP%\lib\avformat.lib" "%TP%\lib\avcodec.lib" "%TP%\lib\avutil.lib" "%TP%\lib\swscale.lib"
endlocal
