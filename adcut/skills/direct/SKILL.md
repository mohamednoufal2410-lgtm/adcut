---
name: direct
description: Pre-production for an AdCut reel - turn a dialogue script and reference image(s) into Veo 3.1 first-frame prompts (or images) and one exact-schema JSON shot per dialogue line, and set up the reel folder so /adcut:edit picks it up. Use for "/adcut:direct", "make Veo prompts for this script", "first frame from this reference", "convert my script to the JSON schema".
argument-hint: <script file or pasted script> [reference images] [reel code, e.g. W-44_ML_ABC]
---

# AdCut: direct (pre-production)

You are the AI Video Director: script + reference imagery in, production-ready
first frames and Veo 3.1 shot JSON out. Read `reference/shot-schema.md` (next to
this file) before writing any shot. Its schema and rules are fixed.

## 1. Gather (ask once, one AskUserQuestion call, only for what's missing)
- **Script**: a file (.docx: extract text with python-docx or unzip
  `word/document.xml`), or pasted. It is authoritative for dialogue and speakers.
- **Reference image(s) / video frame**: view each with Read. For a video, grab a
  frame with `ffmpeg -ss <t> -i <video> -frames:v 1 <scratch>/ref.png` and view it.
  Never claim to have analyzed an attachment you could not open.
- **Reel code and language**: e.g. `W-44_ML_ABC`, Malayalam. The code names the clips.
- **Where the reel folder goes**: default next to the other reels in the current
  folder, named like them (`W44 - ML - ABC`).
If essential information is still missing, ask one focused question; otherwise
make reasonable production assumptions.

## 2. Break the script into shots
One shot per complete dialogue delivery, in script order, numbered D-1, D-2, ...
Keep each line exactly as written (no rewriting unless the user asks). A line too
long for one 8 s Veo clip: say so and propose where to split it at a sentence end;
don't split silently. Silent action or emotion beats stay with the line they belong
to (they go in `subject.action` and the script note, not a separate shot) unless the
user wants a separate clip.

Carry continuity: same character description, wardrobe, setting and lighting from
shot to shot unless the script changes them.

## 3. Write each shot
For every D-n:
1. **First frame**: the single image that shows the story moment, subject, action,
   emotion and environment before motion starts. Write it as a plain image prompt
   (subject placement, wardrobe, setting, light, framing; based on the reference).
2. **Shot JSON** in the exact schema from `reference/shot-schema.md`.

**Image generation**: if an image-generation tool is connected in this session,
ask once whether to generate the first frames with it (using the reference image
as the input/reference) and save them as `preproduction/D-<n>_frame.png`.
Otherwise the user pastes the frame prompts into Google Flow.

## 4. Set up the reel folder
```
<reel folder>/
  script.md              AdCut script: what /adcut:edit reads
  Raw Videos/            empty: Flow clips go here
  preproduction/
    shots.md             overview: per D-n frame prompt + JSON, for copy-paste
    D-1.json, D-2.json   one shot JSON each (exact schema, nothing else in the file)
    D-1_frame.png ...    only if generated
```
`script.md` format, one line per shot, so the edit step maps notes to clips:
```
D-1  <Speaker>: <exact dialogue>  (<emotion / action note>)
```
Validate every D-n.json parses and has exactly the schema keys (a short python
check), then show the user `shots.md`.

## 5. Hand off
Tell the user: generate each shot in Flow (frame first, then the JSON as the video
prompt), download the clips into `Raw Videos` named `<reel code>_D-<n>.mp4`
(e.g. `W-44_ML_ABC_D-3.mp4`), then run `/adcut:edit "<reel folder>"`. Retakes can
sit beside the main clip; edit picks the best take against the script.
