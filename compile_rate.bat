pyinstaller "更新实时汇率.spec"
pyinstaller "手动输入汇率.spec"

copy "dist\JPYRateUpdater.exe" "binary\1st_beat\JPYRateUpdater.exe" /Y
copy "dist\JPYRateManualUpdater.exe" "binary\1st_beat\JPYRateManualUpdater.exe" /Y

pause