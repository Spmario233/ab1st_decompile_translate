# sys_ecatch00 — Japanese → Chinese logo swap: working notes

Source: `..\sys_ecatch00.ogv` — Theora 1280x720 **yuv444p**, 30 fps, 4.5 s, no audio.
Ogg stores **39** frames; the CFR timeline is **130** frames (4.333 s); the container declares
4.500 s.  Background white is `Y=254, U=V=128` (full-range BT.601, same convention as the
other clips in this project).

## Structure

| stored frame | pts | content |
|---|---|---|
| 1 | 0.000 | blank white |
| 2 – 26 | 0.367 … 1.200 | the logo materialises: an ECG streak sweeps in from the left, the logo is wiped in from the left through a heavy blur, the black drop shadow is added at ≈ frame 20 |
| 27 – 39 | 1.600 … 4.300 | the held logo (static) |

## How the new logo was placed

`logo_chinese_small.png` is 682x154 RGBA.  The scale and offset were found by maximising the
silhouette IoU against the source logo:

* scale **0.6050** → 413x93, placed at **(746, 292)** — the same top-left as the source logo,
  whose silhouette is 417x98.  The shared wordmark aligns to within 3 px (760..1161 vs
  760..1158).  The height difference is the artwork's own aspect (the Chinese sub-text is set
  differently), and matching the wordmark matters more than matching the box.

The source logo also has a **black drop shadow** that the supplied PNG does not.  It was
measured against the held frame: offset **(+4,+5)**, blur σ 0.6, strength k **0.962**, fitted by
minimising the residual in the logo box (rms 51.6 without any shadow → 29.6 with it).

## Rendering the reveal

Inside the logo box each source frame's ink is modelled as

    ink(t) = m_x(t) * ( a(t)*blur(BODY, s(t)) + b(t)*blur(SHADOW, s(t)) )  +  r(t)

* `a(t)`, `b(t)` — global per-frame amounts of the logo body and of the shadow
  (recovered: body 0.008 → 1.001, shadow 0.011 → 0.940, the shadow arriving later)
* `s(t)` — per-frame blur, searched over {0, 0.7, 1.2, 1.8, 2.5, 3.4, 4.6, 6.0}; the early
  reveal frames genuinely want σ = 6
* `m_x(t)` — per-column reveal gain (the left-to-right wipe), smoothed with σ_x = 6 px
* `r(t)` — whatever else crosses the box (the ECG streak/glow), kept only where neither logo
  has ink so no Japanese glyph can leak through

Everything is fitted on the ORIGINAL and re-applied to the CHINESE artwork.
`new_all.yuv` holds the 39 re-rendered stored frames; `ec_buildcfr.py` expands them onto the
granulepos schedule (`round(pts*30)`) and `new_final.yuv` pads to 135 frames (4.500 s, the
source's declared length) so the encoder keeps emitting to the end.

Only the box x 720..1185 / y 266..411 is touched — **verified: 0 difference outside it across
all 130 CFR frames.**

## Pipeline

```powershell
$FF = "E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
$PY = "C:\Users\spmar\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
$SRC = "E:\Projects\ab1st_decompile\video\sys_ecatch00\sys_ecatch00.ogv"
$W   = "E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"

# NOTE: ffmpeg -ss on this file returns frames that do not match a sequential decode.
# Always decode the whole stream: 
& $FF -v error -y -i $SRC -fps_mode passthrough -pix_fmt yuv444p -f rawvideo "$W\all.yuv"
& $FF -v error -y -i $SRC -fps_mode cfr -r 30 -pix_fmt yuv444p -f rawvideo "$W\orig_cfr.yuv"

& $PY "$W\ec_align2.py"      # scale + offset  -> align.npy
& $PY "$W\ec_shadowfit.py"   # shadow params   -> shadow.npy
& $PY "$W\ec_render2.py"     # fit + render    -> new_all.yuv, coef3.npy, mask.npy, sig.npy
& $PY "$W\ec_buildcfr.py"    # granulepos expansion -> new_cfr.yuv
# pad to 135 frames as new_final.yuv, then:
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\new_final.yuv" `
      -c:v libtheora -q:v 10 -pix_fmt yuv444p "..\sys_ecatch00_cn.ogv"
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\new_final.yuv" `
      -c:v ffv1 -level 3 -g 1 -slices 4 -slicecrc 1 -pix_fmt yuv444p `
      "..\sys_ecatch00_cn_lossless.mkv"
```

## Quality (this was the priority)

| | bytes | bitrate | note |
|---|---|---|---|
| shipped `sys_ecatch00.ogv` | 251,959 | 448 kbps | ≈ q5.6 — encoding the same content at q5/q6 gives 234 k / 263 k |
| **`sys_ecatch00_cn.ogv`** | **590,689** | 1,050 kbps | **q10, libtheora's maximum** — 2.34x the source |

Encoding the original content at q10 gives 440,283 bytes, i.e. the source is well below q10;
the delivered file is above it.  PSNR of the delivered ogv against the master is
**42.05 dB luma / 45.50 dB average**, and encoding the content at q10 measures 42.11 dB — so
the delivery sits at the ceiling this content allows.

## Verification

* `sys_ecatch00_cn_lossless.mkv`: 135 frames bit-identical to `new_final.yuv`.
* outside the logo box: 0 difference from the source.
* delivered ogv: theora / yuv444p / 30 fps / single stream / no audio, duration 4.4667 s
  (source 4.5000 s).  The 1-frame difference is libtheora's forced-duplicate limit: inputting
  134, 135, 137, 140 or 145 frames all saturate at 4.4667 s.
* reveals and holds both carry `天使的心跳` where the source had `エンジェルビーツ`; no katakana
  remains in any frame.
