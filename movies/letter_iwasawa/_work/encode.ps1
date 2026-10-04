# Encode the rendered frames to the lossless master (FFV1/MKV) and the Theora deliverable (OGV),
# then verify both.
$ErrorActionPreference = 'Stop'
$FF = 'E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe'
$FP = 'E:\Videos\ffmpeg\ffmpeg71\ffprobe.exe'
$W  = 'E:\Projects\ab1st_decompile\video\letter_iwasawa\_work'
$DST = 'E:\Projects\ab1st_decompile\video\letter_iwasawa'
$SRC = "$W\out_full.yuv"
$NF = 3778

if (-not (Test-Path $SRC)) { throw "missing $SRC" }
$len = (Get-Item $SRC).Length
Write-Host ("out_full.yuv = {0} bytes = {1} frames" -f $len, ($len / 2764800))
if ($len / 2764800 -ne $NF) { throw "frame count mismatch" }

Write-Host '--- lossless FFV1 / MKV ---'
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i $SRC `
   -c:v ffv1 -level 3 -g 1 -slices 4 -slicecrc 1 -pix_fmt yuv444p "$DST\ef_iw_letter00_notext_lossless.mkv"

Write-Host '--- Theora q10 / OGV ---'
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i $SRC `
   -c:v libtheora -q:v 10 -pix_fmt yuv444p "$DST\ef_iw_letter00_notext.ogv"

Write-Host '--- verify lossless round trip ---'
& $FF -v error -y -i "$DST\ef_iw_letter00_notext_lossless.mkv" -fps_mode passthrough -pix_fmt yuv444p -f rawvideo "$W\chk_mkv.yuv"
$m1 = (Get-FileHash "$SRC" -Algorithm MD5).Hash
$m2 = (Get-FileHash "$W\chk_mkv.yuv" -Algorithm MD5).Hash
Write-Host "out_full MD5 = $m1"
Write-Host "mkv dec  MD5 = $m2"
Write-Host ("lossless identical: {0}" -f ($m1 -eq $m2))

Write-Host '--- ogv properties ---'
& $FP -v error -show_entries format=duration,size -show_entries stream=width,height,pix_fmt,nb_read_frames -count_frames -select_streams v:0 -of default=nw=1 "$DST\ef_iw_letter00_notext.ogv"

Write-Host '--- PSNR (ogv vs rendered) ---'
& $FF -v info -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i $SRC `
   -i "$DST\ef_iw_letter00_notext.ogv" -lavfi psnr=stats_file="$W\psnr.log" -f null - 2>&1 |
   Select-String 'PSNR' | Select-Object -Last 2
