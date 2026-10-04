# ef_sr_yi00 — subtitle removal: working notes

Source: `..\ef_sr_yi00.ogv` — Theora 1280x720 **yuv444p**, 30 fps, 148 s, no audio.
(The Ogg stores 4185 frames; the CFR timeline is 4436 frames / 147.87 s.)

## Structure of the source

| time | content |
|---|---|
| 0 – ~61 s | the key illustration cross-fading in/out over **white**, with two static credits columns (x 60..445 and x 975..1255) |
| ~61 – 148 s | pure white with centred scrolling credits, ending in the `ef` logo |

## The four files in `..\refrences\` are the exact background

The illustration is not a single image that fades: it is a **cross-fade between the four
supplied plates**.  A per-frame linear compositing model

    frame = white + sum_k w_k(t) * (plate_k - white)

solved over a text-free window fits the source with **rms 1.6 / 255** — i.e. at the level of
the Theora noise.  The recovered weights are a clean convex (sum == 1) walk through the
plates: 1301 fades in, cross-fades to 1302, to 1303, to 1304, then fades out to white.

### Colour range — important

The stream is **full-range BT.601**, not limited.  Evidence:

* the blank background measures **Y = 254, U = V = 128** (limited-range white would be Y = 235);
* interpreting the source as limited-range leaves a ~9 rms mismatch against the supplied
  plates; full-range drops it to ~3 rms with a single plate and ~1.6 rms for the full model.

Anyone re-deriving these plates must convert with `Y = 0.299R+0.587G+0.114B`,
`U = 128+(B-Y)/1.772`, `V = 128+(R-Y)/1.402`.

## Pipeline

| script | purpose | output |
|---|---|---|
| `yui_weights.py` | fit `w_k(t)` for all 1859 frames of the illustration section | `yui_weights_raw.npy`, `yui_fitres.npy` |
| `yui_render.py` | render 4440 frames; white after t = 61.97 s | `yui_out.yuv` (12.3 GB, regenerable) |

```powershell
$FF = "E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
$PY = "C:\Users\spmar\.dsh\dsh-runtimes\dsh-primary-runtime\dependencies\python\python.exe"
$SRC = "E:\Projects\ab1st_decompile\video\ending_yui\ef_sr_yi00.ogv"
$W   = "E:\Projects\ab1st_decompile\video\ending_yui\_work"

& $FF -v error -y -i $SRC -t 62 -pix_fmt yuv444p -f rawvideo "$W\raw_0_62.yuv"   # 2 s
& $PY "$W\yui_weights.py"
& $PY "$W\yui_render.py"

& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\yui_out.yuv" `
      -c:v ffv1 -level 3 -g 1 -slices 4 -slicecrc 1 -pix_fmt yuv444p `
      "..\ef_sr_yi00_notext_lossless.mkv"
& $FF -v warning -y -f rawvideo -pix_fmt yuv444p -s 1280x720 -r 30 -i "$W\yui_out.yuv" `
      -c:v libtheora -q:v 10 -pix_fmt yuv444p "..\ef_sr_yi00_notext.ogv"
```

## Verification

* fit residual: mean 1.62, max 1.95 (grey levels) over the text-free window.
* output frames 0–1858 differ from the source by 0.6–13 rms, the difference being exactly the
  removed glyphs; frames with no glyphs (t = 2, 58, 61) differ by 0.8–1.9 rms.
* every frame from t = 61.97 s on is a flat `Y=254,U=128,V=128` — no bright pixel anywhere.
* `ef_sr_yi00_notext_lossless.mkv`: all 4440 frames **bit-identical** to `yui_out.yuv`.
* `ef_sr_yi00_notext.ogv`: full-timeline PSNR **53.8 dB** average (min 48.3 dB).

The closing `ef` logo (t ≈ 144–147 s) is removed together with the credits, i.e. the tail is
plain white.
