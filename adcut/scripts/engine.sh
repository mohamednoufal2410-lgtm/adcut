#!/usr/bin/env bash
# AdCut engine launcher for the adcut plugin.
#
#   engine.sh <tool> [args...]        run an engine tool:
#       info <folders...>             reels found, clip count, raw length, transcripts
#       transcribe <raw> --lang kn    Whisper word timings -> <raw>/transcripts/
#       transcript <raw>              compact word-timed transcript of every clip
#       adcut <raw> [options]         plan (--plan) or render the edit
#       sheet <video> <png> <t...>    contact sheet of frames around times (s)
#       motion <raw> [clip numbers]   picture movement per 0.25 s (finds silent actions)
#       flares [--sheet out.png]      lens flare assets in the flares folder (+ preview sheet)
#   engine.sh --where                 show which engine is configured
#   engine.sh --configure source <adtools folder>
#   engine.sh --configure exe <path to AdCut.exe> [whisper models folder]
#
# The plugin is copied into Claude Code's cache when installed, so the engine's
# location is remembered in ~/.adcut/engine.conf instead of a relative path.
set -euo pipefail
CONF="$HOME/.adcut/engine.conf"

if [ "${1:-}" = "--configure" ]; then
  kind="${2:?source or exe}"; target="${3:?path}"
  mkdir -p "$(dirname "$CONF")"
  if [ "$kind" = source ]; then
    py="$target/.venv/Scripts/python.exe"
    [ -f "$py" ] || py="$target/.venv/bin/python"
    [ -f "$py" ] && [ -f "$target/app.py" ] || { echo "no app.py + .venv in $target" >&2; exit 2; }
    printf 'ADCUT_KIND=source\nADCUT_PY=%q\nADCUT_APP=%q\n' "$py" "$target/app.py" > "$CONF"
  elif [ "$kind" = exe ]; then
    [ -f "$target" ] || { echo "no AdCut.exe at $target" >&2; exit 2; }
    printf 'ADCUT_KIND=exe\nADCUT_EXE=%q\n' "$target" > "$CONF"
    [ -n "${4:-}" ] && printf 'ADCUT_WHISPER_DIR=%q\n' "$4" >> "$CONF"
  else
    echo "kind must be source or exe" >&2; exit 2
  fi
  echo "configured: $(cat "$CONF" | tr '\n' ' ')"
  exit 0
fi

if [ ! -f "$CONF" ]; then
  echo "AdCut engine is not set up yet. Run /adcut:setup first." >&2
  exit 3
fi
# shellcheck disable=SC1090
source "$CONF"
if [ "${1:-}" = "--where" ]; then
  cat "$CONF"
  exit 0
fi
[ -n "${ADCUT_WHISPER_DIR:-}" ] && export ADCUT_WHISPER_DIR
export PYTHONIOENCODING=utf-8 PYTHONUTF8=1
if [ "$ADCUT_KIND" = exe ]; then
  exec "$ADCUT_EXE" engine "$@"
else
  exec "$ADCUT_PY" "$ADCUT_APP" engine "$@"
fi
