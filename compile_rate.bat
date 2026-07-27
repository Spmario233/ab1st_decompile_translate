pyinstaller "jpy-rate-updater.spec"
pyinstaller "jpy-rate-manual-updater.spec"

copy "dist\JPYRateUpdater.exe" "binary\1st_beat\JPYRateUpdater.exe" /Y
copy "dist\JPYRateManualUpdater.exe" "binary\1st_beat\JPYRateManualUpdater.exe" /Y

pause