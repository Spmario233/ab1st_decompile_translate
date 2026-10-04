cd GameLauncher\

pyinstaller "jpy-rate-updater.spec"

cd ..\

copy "GameLauncher\dist\JPYRateUpdater.exe" "binary\GameLauncher.exe" /Y

pause