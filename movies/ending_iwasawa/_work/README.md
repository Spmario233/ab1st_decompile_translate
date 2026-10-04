# ef_sr_iw00 — subtitle removal: working notes

Source: `..\ef_sr_iw00.ogv`  (Theora, 1280x720 yuv444p, 30 fps, 7830 frames / 261.000 s, no audio)

## What the background actually is

The sky is a **single static image panned vertically at a varying speed** (23.3 px/s at the
start, slowing to ~12.5 px/s around t=52 s, back to ~23 px/s at t=68 s).  Frames aligned by
that offset agree to within ~0.2 grey levels, so the source is a lossless-looking rigid pan.
Total travel over the subtitle region: **1674 px**, giving a master image 1280 x 2394.

## Pipeline

| step | script | output |
|---|---|---|
| decode 0-73 s to native yuv444p | ffmpeg | `raw_0_73.yuv` (regenerable) |
| offset track (30/60/120-frame sub-pixel band-profile matches) | `stage1_recon.py track` | `cum_trk{30,60,120}.npy` |
| robust median mosaic + 4x (register -> robust accumulate) | `stage1_recon.py mosaic` / `iterate` | `mosaic_final.npy`, `cum_final.npy`, `ulo_final.npy` |
| fade fit, grid extension, boundaries | `stage3_render.py` | `fade.npy`, `mosaic_ext.npy`, `bounds.npy` |
| render 7830 frames | `stage3_render.py render` | `out_full.yuv` (regenerable) |
| export the sky image | `stage2_export.py` | `..\sky_background_reconstructed.png` |

### Regenerating everything

```powershell
$FF  = "E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
$PY  = "C:\Users\spmar\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
$SRC = "E:\Projects\ab1st_decompile\video\ending_iwasawa\ef_sr_iw00.ogv"
$W   = "E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"

& $FF -v error -y -i $SRC -t 73 -pix_fmt yuv444p -f rawvideo "$W\raw_0_73.yuv"   # 4 s
& $FF -v error -y -i $SRC -t 73 -fps_mode passthrough "$W\frames\f%05d.png"       # 3 s (band profiles)

& $PY "$W\stage1_recon.py" track      # writes cum_trk30/60/120.npy
& $PY "$W\stage1_recon.py" mosaic     # median mosaic + diagnostic
& $PY "$W\stage1_recon.py" iterate    # 4 registration/accumulation rounds  (~8 min)
& $PY "$W\stage2_export.py"           # sky_background_reconstructed.png
& $PY "$W\stage3_render.py" diag      # fade + boundaries
& $PY "$W\stage3_render.py" render    # out_full.yuv  (~70 s)

# encodes (verified bit-identical for FFV1, 61 dB PSNR for Theora)
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\out_full.yuv" `
      -c:v ffv1 -level 3 -g 1 -slices 4 -slicecrc 1 -pix_fmt yuv444p `
      "..\ef_sr_iw00_notext_lossless.mkv"
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\out_full.yuv" `
      -c:v libtheora -q:v 10 -pix_fmt yuv444p "..\ef_sr_iw00_notext.ogv"
```

`mosaic_preview.yuv` is the raw yuv444p dump of the master image (full-range values,
colour-range tag `tv`, colours as ffmpeg decodes the source).

## Key measurements

* Master image: 1280 x **2394**, master row `u = cum[n] + y` in frame `n`, `cum[0] = 0`.
* Registration residual after convergence: mean 0.059 px, max 0.32 px.
* Robust accumulation rejected ~2.6 % of pixels as subtitle outliers.
* Re-fit fade factor is 1.000 (<=0.09 % error) for every frame before t = 68.57 s.
* First subtitle frame: **n = 733, t = 24.433 s** (`max|frame - sky|` jumps 6.6 -> 182.7).
* Sky fade: starts t = 68.60 s, reaches black at **n = 2163, t = 72.100 s**.
* Source black level is exactly `Y=0, U=V=128`; output black frames use the same values.
* Frames 0-732 are copied byte-for-byte from the source (RMS difference 0.00).
