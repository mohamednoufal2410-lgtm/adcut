# AdCut edit file (edit.json)

All times are seconds **inside that raw clip**. Clip keys are the number at the end of
the file name (`W-39_KA_LR_D-12.mp4` → `"12"`), or the file name without extension for
clips without a number. Include only clips that need something.

```json
{
  "video": "W-39_KA_LR - Skit: you need to close the door",
  "style": {"fx": "auto", "fx_set": "flare", "fade_in": 0, "fade_out": 0},
  "clips": {
    "5":  {"remove": [[2.70, 4.01]], "why": "stray 'Hmm' after the question"},
    "8":  {"emphasis": [[0.0, 4.03, "right"]], "why": "shock beat, speaker on the right"},
    "15": {"remove": [[1.72, 4.01]], "emphasis": [[0.0, 1.72]],
           "why": "Veo repeated the line twice; keep the first take, close on it"},
    "4":  {"keep": [[1.5, 5.6]], "shot": [[1.5, 5.6, "wide"]], "beat": "he walks in",
           "why": "silent entrance from the script, wide so the walk reads"},
    "11": {"keep": [[2.1, 3.4]], "keyframes": [[2.1, 1.0, 0.3, 0.4], [2.25, 1.5, 0.3, 0.4]],
           "beat": "laughs mockingly", "why": "snap punch on the laugher (left)"},
    "16": {"zoom": [[0.5, 4.0, 1.0, 1.35]], "why": "slow push on the offer"},
    "20": {"flash": [3.1], "why": "pop on the price"}
  }
}
```

## style (the reel's look, from the user's choice)

| key | values | meaning |
|---|---|---|
| `fx` | `auto` | transition only where the scene changes between clips (recommended) |
| | `every` | transition on every clip change |
| | `none` | hard cuts with zoom punches only |
| `fx_set` | `flash`, `flare`, `whip`, `fade`, or `flash,whip,flare` (mix) | which transition |
| `flare` | `"name"` or `["a", "b"]` | flare asset(s) from the flares folder (`ENGINE flares` lists them); several take turns. Omit for the drawn flare |
| `flare_pos` | `"top-right"`, `"top-left"`, `"bottom-right"`, `"bottom-left"` or `[x, y]` | built-in flare: one fixed light source for every flare (default: the brightest spot of each shot) |
| `flare_span` | default 0.6 | flare asset: seconds shown each side of its brightest frame |
| `flare_gain` / `flare_wash` | default 1.0 / 0.5 | flare asset brightness / white wash on the cut |
| `fx_frames` | default 6 | frames each side of the cut |
| `fade_in` / `fade_out` | seconds, default 0.4 / 0.8 | from / to black at the start / end. **Always set both to 0: the user never wants fades** |
| `sfx` | `false` | no sound effects |

## per clip

| key | shape | effect |
|---|---|---|
| `remove` | `[[s, e], ...]` | cut these ranges (fillers, repeats, bad takes) |
| `keep` | `[[s, e], ...]` | keep these even though they are silent (script action / reaction beats); `remove` still wins where they overlap |
| `emphasis` | `[[s, e], ...]` or `[[s, e, "left"/"right"]]` | close-up on the speaker |
| `shot` | `[[s, e, "wide"/"medium"/"close"]]` | force a framing |
| `keep_all` | `true` | don't cut silences in this clip (music, action beats) |
| `mute` | `true` | no sound from this clip (montage / B-roll shots); SFX on the cuts still play |
| `after` | `"<clip key>"` | place this clip right after that clip (for unnumbered clips added later, e.g. a regenerated shot) |
| `zoom` | `[[s, e, from, to]]` | eased zoom on the speaker, e.g. 1.0 → 1.4 in, 1.4 → 1.0 out |
| `keyframes` | `[[t, zoom], [t, zoom, "face"], [t, zoom, x, y]]` | camera keyframes; x, y are 0-1 of the frame; needs 2+ keys |
| `transition` | `"flare"`, `"flare:<asset>"`, `"whip-left"`, `"cut"`... | override the transition into this clip (`"cut"` = none) |
| `cut_fx` | `[[t, "flash"]]` | transition on the in-clip cut that starts near t |
| `flash` | `[t, ...]` | white pop accent at t |
| `flare` | `[t, ...]` or `[[t, "<asset>"]]` | lens flare accent centred on t (the style's flare unless an asset is named) |
| `beat` | text | the script's stage direction this clip carries (for reports) |
| `why` | text | one line on the reason, shown in reports |

A flare asset plays at its own speed with its brightest frame on the cut (or accent
time), screen-blended so its black adds nothing; landscape assets are centre-cropped
to the reel. Transitions never change timing: they reuse frames on both sides of the cut, so audio
stays in sync. Zoom never goes below 1.0 (the frame edge).

## What the engine already does without being told
- removes silence and breathing gaps per clip, using each clip's own room tone
- alternates wide / medium framing on in-clip cuts so jump cuts read as punches
- slow push-in on segments of 5 s or longer
- finds the speaker by face + mouth movement for close-ups
- loudness to -14 LUFS, SFX from the sfx folders lined up on each cut
