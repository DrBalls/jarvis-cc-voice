# Bundled Voices - No API Key Required!

JARVIS Voice System now includes **90 pre-generated voice announcements** for all common Claude Code operations, eliminating the need for an ElevenLabs API key for most users.

## Overview

When you install JARVIS from GitHub, you get:
- ✅ **90 high-quality MP3 voice files** (3.8 MB total)
- ✅ **No API key setup required** for standard usage
- ✅ **Instant playback** (no network calls, no latency)
- ✅ **Multiple voice contexts** (success/error/alert tones)
- ✅ **Fallback to system TTS** if audio player unavailable

## What's Included

### Voice Coverage (90 phrases)

**Tool Operations:**
- Edit, Write, Read, Bash, Grep, Glob, Task (pre and post events)

**Git Operations:**
- Commit, push, pull, status, add operations
- "Committing changes to repository" → "Code committed to repository"
- "Pushing to remote repository" → "Changes pushed to remote"
- "Pulling from remote repository" → "Repository synchronized"

**Test Execution:**
- "Initiating test suite execution"
- "Test suite execution complete. All tests passed"
- "Test suite execution complete. Failures detected" (error voice)

**Build Operations:**
- "Initiating build process"
- "Build completed successfully"
- "Build failed. Review errors" (error voice)

**Package Manager:**
- Install, start, dev, build, test scripts
- "Installing dependencies" → "Dependencies installed"
- "Starting development server" → "Server started"

**File & Directory Operations:**
- Creating, reading, copying, moving, removing files
- Listing, creating, changing directories

**Docker Commands:**
- Build, run, start, stop, ps, exec operations

**Process & Network:**
- Process management (checking, terminating)
- Network operations (curl, wget, ping)
- System info (which, env, chmod)

**Event Notifications:**
- "Response cycle concluded. Awaiting further instruction." (alert voice)
- "Auxiliary module has completed its assignment. Systems standing by." (alert voice)

## Voice Types

Three different ElevenLabs voices are used for different contexts:

1. **Success Voice** (ZwQsH4li5bkOUTP3m3d1) - Default confident tone
   - All successful completions
   - Standard tool operations

2. **Error Voice** (pNInz6obpgDQGcFmaJgB - Adam) - Serious tone
   - Test failures
   - Build errors
   - Failed operations

3. **Alert Voice** (EXAVITQu4vr4xnSDxMaL - Bella) - Urgent tone
   - System notifications
   - Stop/SubagentStop events

## Installation

Bundled voices are automatically installed when you run `./install.sh`:

```bash
git clone https://github.com/yourusername/jarvis-cc-voice.git
cd jarvis-cc-voice
./install.sh
```

**Installation locations:**
- Script: `~/.local/bin/cc-voice`
- Bundled voices: `~/.local/share/cc-voice/voices/`
- Hooks: `~/.claude/settings.json`

## How It Works

### Voice Selection Priority

1. **Bundled voices** (checked first)
   - Located in `~/.local/share/cc-voice/voices/`
   - SHA1 hash lookup based on phrase + voice ID + model ID
   - Instant playback, no network required

2. **User cache** (dynamic phrases)
   - Located in `/tmp/cc-voice-cache/`
   - Stores custom phrases generated via API
   - Persists across sessions (temporary directory)

3. **ElevenLabs API** (if API key present)
   - Only called for phrases not in bundled voices or cache
   - Generated audio saved to user cache
   - Requires `ELEVENLABS_API_KEY` environment variable

4. **System TTS fallback** (last resort)
   - macOS: `say` command
   - Linux: `espeak` or `festival`
   - Windows: PowerShell speech synthesizer

### Example Flow

```
User edits a file in Claude Code
↓
PreToolUse hook triggered
↓
cc-voice receives: {"tool_name": "Edit", "hook_event_name": "PreToolUse"}
↓
Phrase generated: "Initiating Edit operation"
↓
SHA1 hash calculated: fda0af861d1ec50410c29fda27fb8a79eaa735a8
↓
Check: ~/.local/share/cc-voice/voices/fda0af861d1ec50410c29fda27fb8a79eaa735a8.mp3
↓
Found! Play immediately via ffplay/afplay
↓
User hears: "Initiating Edit operation" (within milliseconds)
```

## Custom Phrases (Optional API Key)

If you want to generate custom phrases beyond the 90 bundled ones:

1. **Set ElevenLabs API key:**
   ```bash
   export ELEVENLABS_API_KEY="your-api-key"
   export ELEVENLABS_VOICE_ID="ZwQsH4li5bkOUTP3m3d1"
   ```

2. **Custom phrases are auto-generated:**
   - New phrases trigger API call
   - Audio saved to `/tmp/cc-voice-cache/`
   - Reused on subsequent calls

3. **When you might need this:**
   - Custom npm scripts (e.g., "Running lint script")
   - Non-standard commands
   - Specialized Task subagents with unique names

## Developer: Regenerating Voices

If you modify the phrase list or want to regenerate with different voices:

```bash
# Set API key
export ELEVENLABS_API_KEY="your-key"

# Run generation script
cd jarvis-cc-voice
node scripts/generate-voices.js
```

This will:
- Read all phrases from `scripts/generate-voices.js`
- Generate MP3 for each phrase with appropriate voice
- Save to `voices/` directory
- Create `voices/manifest.json` with metadata
- Skip existing files (incremental generation)

**Manifest file** (`voices/manifest.json`):
```json
{
  "generated_at": "2025-10-04T...",
  "voice_ids": {
    "success": "ZwQsH4li5bkOUTP3m3d1",
    "pre": "ZwQsH4li5bkOUTP3m3d1",
    "error": "pNInz6obpgDQGcFmaJgB",
    "alert": "EXAVITQu4vr4xnSDxMaL"
  },
  "model_id": "eleven_flash_v2_5",
  "total_files": 90,
  "phrases": { ... }
}
```

## File Sizes

- **Individual MP3:** ~30-50 KB each
- **Total bundled voices:** ~3.8 MB
- **Git clone impact:** Adds ~4 MB to repository download

This is a reasonable tradeoff for eliminating:
- API key signup/setup friction
- Network latency on every announcement
- API rate limits and costs
- Dependency on external service availability

## Benefits

✅ **Zero configuration** - Works out of the box after `./install.sh`
✅ **Fast playback** - No network calls, instant audio
✅ **Offline capable** - Works without internet connection
✅ **Consistent experience** - Same voice quality for all users
✅ **No API costs** - No rate limits or usage charges
✅ **Privacy** - No data sent to external services (unless using custom phrases)
✅ **Reliable** - No dependency on API uptime

## Limitations

- **Fixed phrases only** - Bundled set covers common operations but not everything
- **Voice customization** - Requires API key to use different voices
- **Storage** - Adds ~4 MB to git clone size
- **Updates** - New phrases require regeneration and git pull

## Migration from API-Only Version

If you were using JARVIS before bundled voices:

**No action required!** The system is fully backward compatible:
- Existing cache in `/tmp/cc-voice-cache/` still works
- API key configuration still works for custom phrases
- Voice selection logic unchanged
- Simply `git pull` and re-run `./install.sh`

## Troubleshooting

**Bundled voices not playing:**
```bash
# Check if voices were installed
ls -la ~/.local/share/cc-voice/voices/

# Should show 91 files (90 MP3s + manifest.json)
# If missing, re-run installer:
cd jarvis-cc-voice
./install.sh
```

**Custom phrases not generating:**
```bash
# Check API key is set
echo $ELEVENLABS_API_KEY

# Test direct generation
node bin/cc-voice --phrase "My custom phrase"
```

**Want to remove bundled voices:**
```bash
# Remove installation
rm -rf ~/.local/share/cc-voice/

# System will fall back to API or TTS
```

## Future Enhancements

Potential improvements for bundled voices:

- [ ] Voice pack selector (different voice styles)
- [ ] Compressed audio format (reduce size)
- [ ] Localization (multiple languages)
- [ ] Phrase expansion (more common variations)
- [ ] Update script (pull latest voices without reinstall)
- [ ] Custom phrase bundles (user-generated packs)

---

**Questions or issues?**
Open an issue at: https://github.com/yourusername/jarvis-cc-voice/issues
