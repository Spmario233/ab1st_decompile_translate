# ef_sr_mt00 — subtitle removal: working notes

Source: `..\ef_sr_mt00.ogv` — Theora 1280x720 **yuv444p**, 30 fps, 263 s (7890 CFR frames),
no audio.  The Ogg stores 7502 packets; the CFR timeline is 7890 frames.

## Structure of the source

| frames | time | content |
|---|---|---|
| 0 – 287 | 0 – 9.6 s | opening scene (full frame, no credits) |
| 288 – 713 | 9.6 – 23.8 s | blank white |
| 714 – 6629 | 23.8 – 221.0 s | **scrolling credits in the left column** on white, plus a sunflower photo inset on the right (x >= 802) |
| 6630 – 6810 | 221.0 – 227.0 s | blank white |
| 6811 – 7397 | 227.0 – 246.6 s | the sunflower photo fills the frame |
| 7398 – 7430 | 246.6 – 247.7 s | blank white |
| 7431 – 7829 | 247.7 – 261.0 s | the `ef` logo on white |
| 7830 – 7889 | 261.0 – 263.0 s | global fade of the whole frame to black |

Measured credits bounding box over the whole credits section: **x 195..759, y 0..719**.
The sunflower inset never comes left of x = 802, so `x in [140, 790]` contains credits only.

The background behind the credits is flat white — `Y = 254, U = V = 128` (measured on the
blank frames, and on the left half of every credits frame).

## Processing

`mt_render.py` copies every frame and, inside the credits column, replaces any pixel with
`Y < 252` by the background `(254, 128, 128)`.  The logo section is cleared the same way over
the whole frame (that part of the video is logo-on-white only).  Nothing else is touched, so
the opening scene, the sunflower inset, the full-screen sunflower and the closing fade to
black all pass through bit-for-bit.

```powershell
$FF = "E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
$PY = "C:\Users\spmar\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
$SRC = "E:\Projects\ab1st_decompile\video\ending_matsushita\ef_sr_mt00.ogv"
$W   = "E:\Projects\ab1st_decompile\video\ending_matsushita\_work"

& $FF -v error -y -i $SRC -pix_fmt yuv444p -f rawvideo "$W\raw.yuv"                # 27 s
& $PY "$W\mt_render.py"

& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\mt_out.yuv" `
      -c:v ffv1 -level 3 -g 1 -slices 4 -slicecrc 1 -pix_fmt yuv444p `
      "..\ef_sr_mt00_notext_lossless.mkv"
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\mt_out.yuv" `
      -c:v libtheora -q:v 10 -pix_fmt yuv444p "..\ef_sr_mt00_notext.ogv"
```

The plate-zone / logo-zone bounds were derived by `mt_ranges.py` and `mt_zone.py`, which scan
the whole decoded stream for non-white pixels.

## Verification

* `ef_sr_mt00_notext_lossless.mkv`: all 7890 frames **bit-identical** to `mt_out.yuv`.
* `ef_sr_mt00_notext.ogv`: duration exactly 263.000 s, full-timeline PSNR **55.6 dB** average
  (luma 53.7 dB, min 46.7 dB).
* frames outside the credits / logo ranges are byte-for-byte the source (`changed_px == 0` in
  `mt_verify.py` at n = 0, 300, 600, 6634, 7000, 7400, 7833 … 7889).
* after clearing, the credits column and the logo section contain no pixel below Y = 252.

## Note on extraction

For this file `ffmpeg -ss <t> -i src` (input seeking) returns frames that do not match a
sequential decode, because of the Theora granulepos duplicate-frame structure.  All analysis
above used a full sequential decode (`raw.yuv`), which is the authoritative timeline.
