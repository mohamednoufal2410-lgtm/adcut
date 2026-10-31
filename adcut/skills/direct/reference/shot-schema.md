# Veo 3.1 shot schema and rules

Use exactly this JSON for every shot. Never add, remove, rename or restructure
fields. Fill every string; leave none empty unless it truly doesn't apply.

```json
{
  "style": "",
  "composition": "",
  "camera_motion": "",
  "lighting_mood": "",
  "film_grain": "",
  "subject": {
    "description": {
      "age": "",
      "ethnicity": "",
      "skin_tone": "",
      "attire": "",
      "expression": ""
    },
    "action": ""
  },
  "audio": {
    "dialogue": "",
    "voice": {
      "tone": "",
      "accent": "",
      "nationality": "",
      "gender": "",
      "speed": 1.0,
      "style_tags": [],
      "pitch": ""
    }
  },
  "negative_prompt": ""
}
```

## Rules
- **Dialogue** is copied exactly from the script, in its own script (Malayalam,
  Kannada, ... or code-mixed English as written). One complete, uninterrupted
  delivery: no breathing spaces, pauses, split lines, ellipses or fragmented
  delivery instructions. (Pauses Veo adds anyway are cut later by /adcut:edit.)
- **Speaker** identity comes from the script. One speaking subject per shot.
- **Prompt for Veo 3.1's lower-priority model**: explicit, simple, robust. No
  subtle effects, no ambiguous wording. Clear subject placement, action, lighting,
  camera direction and continuity cues.
- **Reference first**: carry the reference's visual style, character appearance,
  wardrobe, setting, lighting, composition and cinematic language unless the
  script requires a change.
- **film_grain**: `"none"` unless the user asks for grain.
- **camera_motion**: restrained. `"static opening frame"` is often right; a slow
  push-in at most for emotional beats. No decorative effects.
- **voice**: consistent with the character and the scene across all their shots;
  `speed` 1.0 unless asked; accent/nationality match the language (e.g. Malayali
  accent, Indian).
- **negative_prompt**: only the failure modes that matter here, e.g. extra people
  speaking, lip-sync drift, subtitles or on-screen text, distorted hands or faces,
  background music, wardrobe changes.
