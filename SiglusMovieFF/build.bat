@echo off
rem ---------------------------------------------------------------------------
rem Build SiglusMovieFF.dll (32-bit) with the MSVC toolchain.
rem Run from anywhere; paths are derived from this script's location.
rem ---------------------------------------------------------------------------
setlocal

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
set "SRC=%ROOT%\src"
set "TP=%ROOT%\third_party\ffmpeg"
set "BUILD=%ROOT%\build"
set "DIST=%ROOT%\dist"

if not exist "%BUILD%" mkdir "%BUILD%"
if not exist "%DIST%"  mkdir "%DIST%"

rem ---- locate Visual Studio ------------------------------------------------
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo [build] vswhere.exe not found at "%VSWHERE%"
  exit /b 1
)
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSPATH=%%i"
if not defined VSPATH (
  echo [build] no Visual Studio installation with C++ tools found
  exit /b 1
)
echo [build] VS: %VSPATH%

call "%VSPATH%\VC\Auxiliary\Build\vcvars32.bat" >nul
if errorlevel 1 (
  echo [build] vcvars32.bat failed
  exit /b 1
)

set "CFLAGS=/nologo /c /W3 /O2 /MT /GS- /EHsc /std:c++17 /DNDEBUG /D_CRT_SECURE_NO_WARNINGS /D_WIN32_WINNT=0x0601 /DWINVER=0x0601 /DU_STATIC_IMPLEMENTATION /wd4819 /utf-8"
set "CFLAGS=%CFLAGS% /I"%SRC%" /I"%TP%\include""
set "LDFLAGS=/nologo /DLL /DEF:"%SRC%\SiglusMovieFF.def" /OUT:"%DIST%\SiglusMovieFF.dll" /IMPLIB:"%BUILD%\SiglusMovieFF.lib" /PDB:"%BUILD%\SiglusMovieFF.pdb" /MAP:"%BUILD%\SiglusMovieFF.map" /OPT:REF /OPT:ICF"

echo [build] compiling...
cl %CFLAGS% /Fo"%BUILD%\\" "%SRC%\log.cpp" "%SRC%\audio_out.cpp" "%SRC%\video_out.cpp" "%SRC%\player.cpp" "%SRC%\mci.cpp" "%SRC%\dllmain.cpp"
if errorlevel 1 exit /b 1

echo [build] linking...
link %LDFLAGS% "%BUILD%\log.obj" "%BUILD%\audio_out.obj" "%BUILD%\video_out.obj" "%BUILD%\player.obj" "%BUILD%\mci.obj" "%BUILD%\dllmain.obj" ^
     "%TP%\lib\avformat.lib" "%TP%\lib\avcodec.lib" "%TP%\lib\avutil.lib" "%TP%\lib\swscale.lib" "%TP%\lib\swresample.lib" ^
     winmm.lib ole32.lib oleaut32.lib user32.lib gdi32.lib advapi32.lib shell32.lib
if errorlevel 1 exit /b 1

echo [build] building test host...
cl /nologo /W3 /O2 /MT /EHsc /D_CRT_SECURE_NO_WARNINGS /Fo"%BUILD%\\" /Fe"%DIST%\FakeMovieHost.exe" "%ROOT%\tools\fake_host.cpp" "%ROOT%\tools\crashdiag.cpp" winmm.lib user32.lib gdi32.lib dbghelp.lib
if errorlevel 1 exit /b 1

echo [build] building injector...
cl /nologo /W3 /O2 /MT /D_CRT_SECURE_NO_WARNINGS /Fo"%BUILD%\\" /Fe"%DIST%\DllInjector.exe" "%ROOT%\tools\injector.cpp" user32.lib
if errorlevel 1 exit /b 1

echo [build] collecting FFmpeg runtime DLLs...
for %%f in (avcodec-61.dll avformat-61.dll avutil-59.dll swscale-8.dll swresample-5.dll) do (
  if exist "%TP%\%%f" copy /y "%TP%\%%f" "%DIST%\" >nul
)

echo.
echo [build] OK
dir /b "%DIST%"
endlocal
