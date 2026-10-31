---
name: setup
description: One-time AdCut setup - find the AdCut engine on this PC, check GPU, ffmpeg, the Whisper speech model and the SFX folders, and remember the engine for /adcut:edit. Use when /adcut:edit says the engine is not set up, or the user asks to set up or repair AdCut.
---

# AdCut setup

The engine launcher is `scripts/engine.sh` two folders above this skill's base
directory. Call it as `bash "<base>/../../scripts/engine.sh" ...` (quote the path,
it may contain spaces). Below, `ENGINE` means that command.

## 1. Find the engine

Check in this order and use the first that exists:

1. **Source checkout** (preferred: always current, uses the existing model folder):
   an `adtools` folder containing `app.py` and `.venv/`. Look in the current
   working directory and its parent, then ask the user for the path if not found.
   Configure: `ENGINE --configure source "<adtools folder>"`
2. **Installed app**: `$LOCALAPPDATA/Programs/AdCut/AdCut.exe`, or a
   `dist/AdCut/AdCut.exe` inside the adtools folder.
   Configure: `ENGINE --configure exe "<AdCut.exe>" ["<whisper models folder>"]`
   Pass the third argument only if a `models/whisper/large-v3/model.bin` already
   exists somewhere (e.g. in an adtools folder), to avoid a second 3 GB download.

Confirm with `ENGINE --where`.

## 2. Health checks (report each as ok / problem)

- Engine runs: `ENGINE info "<any folder with clips>"`, or just `ENGINE info .`
  (an empty result is fine; an error is not).
- GPU: `nvidia-smi --query-gpu=name,memory.total --format=csv,noheader`
  (no NVIDIA GPU: transcription still works on CPU, several times slower).
- Whisper model: present if `<adtools>/models/whisper/large-v3/model.bin` exists
  (source mode) or under `$LOCALAPPDATA/AdCut/models/whisper` (exe mode).
  If missing, say the first transcription downloads about 3 GB once.
- SFX: list how many files are in each of `whoosh`, `flash`, `flare`, `zoom` under
  `<adtools>/sfx/` (source) or `$LOCALAPPDATA/AdCut/sfx/` (exe). Empty folders
  are fine; those effects play silent. Point to `sfx/README.txt` for what to add.
- Flares: count files in `<adtools>/flares/` (source) or `$LOCALAPPDATA/AdCut/flares/`
  (exe). Empty is fine (the drawn flare is used); say they can drop their own lens
  flare / light leak videos (on black) there.
- Free RAM: `powershell -c "[int]((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)"`.
  Under ~3500 MB, warn that transcription loads a ~3 GB model and suggest closing
  Premiere and browsers before editing.

End with one line: ready, or the one thing still needed.
