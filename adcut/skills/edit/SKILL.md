---
name: edit
description: Edit one or more AI ad reels into finished videos with AdCut. Each reel is a folder of Google Flow / Veo clips (a "Raw Videos" folder or the clips themselves). Cuts breathing pauses, fillers and repeated takes by reading word-timed transcripts against the script, keeps and stages the script's silent action and emotion beats (passing a phone, a mocking laugh, hiding in embarrassment), keeps the peak of emotional moments (crying, a quiet moment), adds close-up punches, the reel's chosen transition (flash, lens flare from the user's flare assets, whip pan, fade), SFX and fades, then renders and checks the result. Use for "/adcut:edit <folders>", "edit these reels", "cut this ad", or changes to an AdCut edit ("add a flare on clip 14", "re-render without the whip").
argument-hint: <reel folder> [more folders] [script file]
---

# AdCut: edit reels

`ENGINE` below means `bash "<this skill's base directory>/../../scripts/engine.sh"`
(quote it, the path may have spaces). If it exits with "not set up", run the
`setup` skill of this plugin first, then continue.

Read `reference/edit-format.md` (next to this file) before writing an edit file.

## 1. Find the reels
`ENGINE info <folders the user gave>` prints one JSON line per reel: name, project
folder, raw clips folder, clip count, raw length, transcripts done, edit.json present,
and `notes`: script / dialogue files found in the reel folder. A reel's finished video
goes to `<project>/<reel>_cut.mp4`.

**The script comes with the reel.** The user keeps it in the reel folder, numbered by
dialogue: D1 / D-1 is clip `..._D-1.mp4`, with each dialogue's emotion or action
written next to it. Read it from `notes` (a .docx: extract its text with python-docx
or unzip `word/document.xml`); don't search elsewhere and don't ask for a script
when one is there. Map every emotion / action note to its clip by the D number.

## 2. Ask once per reel, before any long work
A reel is one finished video (one folder of clips), so these choices hold for that
whole video. Use AskUserQuestion (one call, up to 4 questions; group reels when several share a choice):
- **Transition**: Flash / Lens flare / Whip pan / Fade (Other: "None" = hard cuts with
  zoom punches only, "Mix" = flash, whip, flare in turn). Use only the chosen type.
- **Which flare** (only when the transition or accents use a flare): run
  `ENGINE flares --sheet "<scratch>/flares.png"`, show the user the sheet
  (SendUserFile when available, else give its path) and ask with the asset names as
  options (multiSelect: several picked take turns), plus "Built-in" for the drawn
  flare. Put the pick in `style.flare`. If the flares folder is empty, say so and use
  the built-in one. Skip if the user named a flare already.
- **Where**: On scene changes (Recommended) / Every clip change.
- **Language** if not obvious from the folder name (KA/kn Kannada, ML Malayalam,
  TA Tamil, TE Telugu, HI Hindi). Code-mixed English is normal.
- **Script**: only if `notes` found none: ask the user to paste it or give a path;
  editing without one works but must be more conservative.
Skip a question when the user already answered it in their message, e.g.
`/adcut:edit "E:\...\W-40_ML" flare, scene changes, malayalam` + the script needs no
questions at all. With several reels and one answer, apply it to all of them.

## 3. Transcribe
`ENGINE transcribe "<raw>" --lang <kn|ml|ta|te|hi|en>`. Always pass `--lang`: auto
detection translates code-mixed clips into English. Already-transcribed clips are
skipped. Loads a ~3 GB model on the GPU; if this PC is low on RAM, ask the user to
close Premiere and browsers first. Never pass a clip's own line as `--prompt`
(Whisper then skips it). Takes about 2-4 s per clip.

## 4. Read and decide
`ENGINE transcript "<raw>"` prints every clip as `word[start-end]`. Read it against the
script. Silence and breathing gaps are removed automatically; you only mark what
silence detection cannot catch:

**remove** `[start, end]` (seconds inside that clip)
- fillers and stray sounds not in the script: hmm, uh, aah, a laugh, a cough
- repeated lines: Veo often re-speaks the previous clip's last line at the start of the
  next clip, or says its own line twice. Keep one clean, complete take.
- extra words or a garbled tail after the scripted line ends
- a wrong word only if cutting it leaves a clean sentence; never cut mid-word
Cut from just after the last kept word ends to just before the next kept word starts.
Never remove a clip's whole dialogue. Without a script: only fillers, stray sounds and
words plainly spoken twice in a row, each removal under 2 s unless a whole sentence repeats.

**emphasis** `[start, end]` or `[start, end, "left"|"right"]`: close-up on lines that sell:
the hook, the pain point, the offer or price, numbers, the product's unique point, a
surprise or reaction beat, the closing promise. About one clip in three, 1-4 s each,
covering whole words. Add a side only when two people share the frame and the script
makes the speaker's side clear.

**Framing rule:** the person speaking stays in frame at a proper position nearly all
the time: face never cut off by the crop, no zoom onto empty space or a bystander.
Face tracking can miss in crowds; then place the close-up by hand with `keyframes`
x, y. Exception, a judgement call: show the OTHER character when their reaction
carries the story (shock, embarrassment, hurt), e.g. the husband's jaw drop while
his wife speaks fluent English; then go back to the speaker.

Optional, sparingly and only when it serves the line: `zoom` / `keyframes` for a slow
push on a long reveal, a `flash` accent on a single punchline word. Do not add
transitions beyond the user's choice.

### Script beats (no dialogue, but they carry the story)
Scripts mark actions and emotions between lines: "(takes out the phone)", "[passes
the phone]", "laughs mockingly", "hides face in embarrassment", "*shocked*", a line
with no speaker. These must read clearly in the edit; silence cutting removes them
unless you keep them. For each beat:

1. **Place it.** Find its clip from the script order (the line before / after it).
2. **Find when it happens.** `ENGINE motion "<raw>" <clip numbers>` prints picture
   movement per 0.25 s (one digit, 0 still .. 9 big; a space every second). Talking
   heads sit at 0-2; an action is a run of higher digits, usually in a gap between
   words in the transcript. If the run is unclear or the beat is subtle (a look, a
   smirk), check frames: `ENGINE sheet "<raw clip file>" "<scratch>/beat.png" <t1> <t2>`.
   Laughs, gasps and sighs are sounds, so they show in the audio and may appear in
   the transcript as "haha" / "hmm".
3. **Keep it**: `keep` `[start, end]` from the start of the movement to just after
   it settles, usually 0.8-2.5 s. Trim the still lead-in and tail. Never remove a
   laugh, sigh or gasp the script asks for (only unscripted ones are fillers).
4. **Stage it** to match the emotion:

| beat | examples | treatment |
|---|---|---|
| object / reveal | takes out the phone, passes the phone, shows the product, opens the box | `shot` wide or medium so the hands show; if the object is small, `keyframes` easing in toward it (x, y read off the sheet); optional `flash` on the reveal frame |
| mocking / gloating | laughs mockingly, smirks, points and laughs | keep ~1-1.5 s of the laugh; snap punch-in on the laugher: `keyframes` `[t,1.0,x,y],[t+0.15,1.5,x,y]` |
| embarrassment / hurt | hides face, looks down, shrinks back | slow push-in on that person (`zoom` 1.2 → 1.5 over the beat), let it breathe; no flash |
| shock / surprise | jaw drop, freezes, turns sharply | `emphasis` or `shot` close on the reacting face, cut right after the peak |
| entrance / exit | walks in, storms off | keep the movement, `shot` wide; trim dead frames before they enter |
| awkward or dramatic pause | silence, staring | keep 0.6-1 s of it, `shot` medium or close |
| sad / emotional moment | crying, tears, "having a moment", heartbroken, overwhelmed, lost in thought | keep only the peak, 1.5-2.5 s (never the whole 4-5 s the clip holds): the tear rolling, the face crumpling, the breath that breaks. Slow push-in (`zoom` 1.1 → 1.35) on that person; no flash or flare on or into it; a sob or sniff in the audio stays |

**Emotional moments are a must-keep, but short.** Any note in the script about
feelings (crying, a moment, sadness, longing, relief) gets a `keep` even when the clip
has no line there, trimmed to the most expressive 1.5-2.5 s. Find that stretch with
`motion` (crying shows as a steady run of 2-4s, not a spike) and confirm with one
`sheet` row; if two stretches look alike, take the later one, nearer the next line.

For silent reactions, anchor `keyframes` with x, y (0-1 of the frame) instead of
"face": face tracking follows mouth movement, so it may pick the wrong person when
nobody speaks. Put the beat's script text in the clip's `"beat"` field.

Indian-language transcripts are imperfect: judge by sound-alike words and the script's
meaning, not spelling. When unsure, don't cut.

## 5. Write the edit and check the plan
Write `<project>/edit.json` (format in `reference/edit-format.md`), with the user's
choice in `"style"` and a short `"why"` per clip. Then:
`ENGINE adcut "<raw>" --edit "<project>/edit.json" --plan`
Check: every script beat's `keep` range appears as a kept segment, the reported removal is plausible (typically 25-35% of raw for Flow clips), no
segment you meant to keep is missing, transitions (`<flash>` etc.) sit only where
intended, and close-ups (`*`) are where you put them.

## 6. Render
`ENGINE adcut "<raw>" --edit "<project>/edit.json" -o "<project>/<reel>_cut.mp4"`
Renders at roughly real time (a 2-3 min raw reel takes about 2-3 min). Use a Bash
timeout of 600000 ms. With several reels, run a render in the background
(`run_in_background`) and write the next reel's edit meanwhile; never transcribe while
a render runs on a low-RAM PC, and never run two renders at once.

### Premiere Pro timeline (when the user wants to fine-tune by hand)
`ENGINE adcut "<raw>" --edit "<project>/edit.json" --xml "<project>/<reel>_premiere.xml"`
writes an FCP7 XML Premiere imports (File > Import): V1 cut pieces with the camera as
Motion Scale/Position (keyframed where it moves), flare assets on V2/V3 in Screen mode,
linked A1/A2 with muted clips disabled. Takes ~2 min (face finding), no render. Not
carried over: loudness, SFX, drawn flash/whip effects (marked), flare wash.

## 7. Verify before reporting
- Duration: `ffprobe -v error -show_entries format=duration -of csv=p=0 "<out>"`.
- Effects: the render writes `<out>.cuts.json`; segments with a `"tin"` value start a
  transition at `"out_t"` seconds. Make one contact sheet of up to 3 of them, swapping one row for the strongest
script beat if the reel has any (its `out_t` from the cuts file):
  `ENGINE sheet "<out>" "<scratch>/check.png" <t1> <t2> <t3>` and look at it
  (Read the PNG). Confirm the effect shows and nothing is broken (black frames,
  wrong framing). Also grab one frame inside every close-up / zoom and confirm it
  lands on the speaker's face (or on the intended reaction). Then delete `<out>.cuts.json` and the sheet.
- Report per reel: raw length → final length, cuts made (with the why), script beats
  and how each was staged, close-ups,
  where the transitions landed, output path. Keep it short.

## 8. Changes after review
Edit `edit.json` (don't start over) and re-render. For a quick look at a change, add
`--preview` (fast, lower quality) and render the final again once approved.

## Keep token use low
Read the compact `transcript` output, never the raw transcript JSON. Don't print or read
the full `--plan` for long reels more than once. One contact sheet per reel is enough.
