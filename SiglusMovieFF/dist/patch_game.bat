@echo off
rem ---------------------------------------------------------------------------
rem Make SiglusEngine load SiglusMovieFF.dll at startup.
rem
rem   patch_game.bat <path-to-SiglusEngine.exe>
rem   patch_game.bat <path-to-SiglusEngine.exe> --revert
rem
rem Adds one import to the executable (see tools\patch_add_import.py for the
rem details and why it is more involved than appending a descriptor).  A backup
rem named <exe>.preimport is written next to it the first time.
rem ---------------------------------------------------------------------------
setlocal

if "%~1"=="" (
  echo usage: patch_game.bat ^<path-to-SiglusEngine.exe^> [--revert]
  exit /b 2
)

set "HERE=%~dp0"
if "%HERE:~-1%"=="\" set "HERE=%HERE:~0,-1%"

set "PY="
where py >nul 2>&1 && set "PY=py -3"
if not defined PY (
  where python >nul 2>&1 && set "PY=python"
)
if not defined PY (
  echo [patch] no Python found on PATH; install Python 3 or run the patch manually.
  exit /b 1
)

if "%~2"=="--revert" (
  %PY% "%HERE%\tools\patch_add_import.py" "%~1" --revert
) else (
  %PY% "%HERE%\tools\patch_add_import.py" "%~1" SiglusMovieFF.dll --symbol SmfImportAnchor
)
if errorlevel 1 (
  echo [patch] FAILED
  exit /b 1
)

echo.
echo [patch] done.  Make sure these files sit next to the executable:
echo         SiglusMovieFF.dll  avcodec-61.dll  avformat-61.dll
echo         avutil-59.dll      swscale-8.dll   swresample-5.dll
endlocal
