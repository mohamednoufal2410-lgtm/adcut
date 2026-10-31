# AdCut for Claude Code

Edit AI ad reels (Google Flow / Veo clips) by chatting with Claude: it cuts
breathing pauses, fillers and repeated takes against your script, keeps the
silent action and emotion beats, punches in on cuts, and adds your transition,
SFX and fades. Kannada, Malayalam, Tamil, Telugu, Hindi, English.

## What you need

- Windows 10/11 64-bit, NVIDIA graphics card recommended, 8 GB RAM or more
- Your **own** Claude Pro/Max account and Claude Code ([claude.com/claude-code](https://claude.com/claude-code))
- The **AdCut app** (the editing engine), from whoever shared this with you.
  It's free, no key needed.

## Install

1. **Install the AdCut app.** Run `AdCut-Setup-1.1.exe` (installs for your user,
   no admin prompt).
2. **Add the plugin in Claude Code** (terminal `claude`, or the Code tab in the
   Claude desktop app):

   ```
   /plugin marketplace add mohamednoufal2410-lgtm/adcut
   /plugin install adcut@adcut-local
   ```

   This is a private repo, so you need to be added as a collaborator and be
   signed in to GitHub on your PC (`gh auth login`, or Git Credential Manager).
3. **Run setup once:** `/adcut:setup`. It finds the app, checks the GPU, speech
   model, SFX and flare folders, and tells you if anything is missing.

## Use

**Pre-production** (script + reference image → Veo 3.1 prompts):

```
/adcut:direct "D:\Scripts\W44 ML ABC.docx" "D:\Refs\ref.png" W-44_ML_ABC
```

Claude writes a first-frame prompt and an exact-schema Veo JSON per dialogue
line, and sets up the reel folder (`script.md`, `Raw Videos`, `preproduction/`).
Generate the clips in Google Flow, save them into `Raw Videos` as
`W-44_ML_ABC_D-1.mp4`, `..._D-2.mp4`, ...

**Edit:**

```
/adcut:edit "D:\Reels\W44 - ML - ABC"
```

Pass one or more reel folders (a folder with a `Raw Videos` folder inside, or
the clips themselves). Put the script in the reel folder for best results.
Claude asks which transition you want, edits, renders, and checks the result.
Then just tell it what to change ("tighten clip 3", "no whip on clip 7").

Optional: drop your own sound effects into `%LOCALAPPDATA%\AdCut\sfx\`
(`whoosh`, `flash`, `flare`, `zoom`) and lens flare / light leak videos on
black into `%LOCALAPPDATA%\AdCut\flares\`.

## Updates

```
/plugin marketplace update adcut-local
```

New engine features need a new AdCut app installer as well.
