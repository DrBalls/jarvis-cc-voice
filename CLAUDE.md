# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

JARVIS Voice is an intelligent voice notification system for Claude Code that provides real-time audio feedback during operations. It uses Claude Code's hooks system to announce tool executions with context-aware phrases and dynamic voice selection.

**Cross-platform support**: macOS, Linux, and Windows (Git Bash/WSL/PowerShell)

## Architecture

### Core Components

1. **`bin/cc-voice`** (Node.js script)
   - Main voice engine that processes hook events from stdin
   - Detects tool types, commands, and context from hook payloads
   - Implements smart phrase generation based on operation type
   - Manages ElevenLabs API integration with local audio caching
   - Provides multi-platform audio playback fallback chain
   - Dynamic voice selection (success/error/pre/alert contexts)

2. **`config/claude-settings-hooks.json`**
   - Hook configuration template for `~/.claude/settings.json`
   - Defines matchers for all major Claude Code tools:
     - `PreToolUse`: Edit, Write, Read, Bash, Grep, Glob, Task
     - `PostToolUse`: Same tools with completion phrases
     - Event hooks: Stop, SubagentStop, SessionEnd, Notification
   - Each hook invokes `cc-voice` script via command execution

3. **`install.sh`**
   - Cross-platform automated installer (bash-based)
   - Copies `cc-voice` to `~/.local/bin/`
   - Merges hooks into existing `~/.claude/settings.json` or creates new one
   - Optional ElevenLabs API key setup (writes to shell profile)
   - Creates backup of existing settings before modification

### Voice System Logic

**Context Detection Flow** (`bin/cc-voice`):
1. Read JSON payload from stdin (hook event data)
2. Extract: `hook_event_name`, `tool_name`, `tool_input`, `tool_response`
3. Run context detection on Bash commands:
   - Git operations: commit, push, pull, status, diff, add
   - Test execution: npm/pytest/jest with pass/fail analysis
   - Build operations: npm/cargo/make with success/error detection
   - Package managers: install, start, run scripts
4. Run context detection on Task tool:
   - Extract subagent type from description
   - Announce specific agent names (e.g., "Launching Code Reviewer agent")
5. Select appropriate voice based on context (success/error/alert)
6. Generate or retrieve cached audio
7. Play audio using platform-appropriate command

**Audio Playback Fallback Chain**:
1. ElevenLabs API (if API key present) → cache to `/tmp/cc-voice-cache/`
2. macOS: `afplay` for files, `say` for TTS
3. Linux: `ffplay` or `aplay` for files, `espeak`/`festival` for TTS
4. Windows: PowerShell TTS or media player

## Common Development Commands

### Testing the Voice System

```bash
# Test voice script directly with custom phrase
node bin/cc-voice --phrase "Testing JARVIS voice system"

# Or using npm script
npm test

# Test with simulated hook payload
echo '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"git commit"}}' | node bin/cc-voice
```

### Installation and Setup

```bash
# Run automated installer
./install.sh

# Manual installation
cp bin/cc-voice ~/.local/bin/cc-voice
chmod +x ~/.local/bin/cc-voice
cp config/claude-settings-hooks.json ~/.claude/settings.json

# Verify installation
which cc-voice
cc-voice --phrase "Installation verified"
```

### Environment Configuration

```bash
# Set ElevenLabs API key (required for AI voices)
export ELEVENLABS_API_KEY="your-api-key"

# Customize voice IDs for different contexts
export ELEVENLABS_VOICE_SUCCESS="voice-id"  # Default operations
export ELEVENLABS_VOICE_ERROR="voice-id"    # Errors/failures
export ELEVENLABS_VOICE_PRE="voice-id"      # PreToolUse events
export ELEVENLABS_VOICE_ALERT="voice-id"    # Notifications

# Override audio player
export CC_VOICE_PLAYER="afplay"  # or "say", "ffplay", "pwsh"

# See docs/VOICE-IDS.md for complete list of ElevenLabs voices
```

### Hook Configuration

After installation, hooks are configured in `~/.claude/settings.json`. To modify:

```bash
# View current hooks
cat ~/.claude/settings.json | jq '.hooks'

# Edit settings
code ~/.claude/settings.json  # or vim/nano

# Restore from backup if needed
cp ~/.claude/settings.json.backup ~/.claude/settings.json
```

## Adding New Features

### Adding New Context Detection

Edit `bin/cc-voice`, locate the `detectContext()` function (around line 32):

```javascript
function detectContext() {
  const descLower = desc.toLowerCase();
  const command = toolInput?.command || "";

  // Add your new pattern detection
  if (tool === "Bash" && commandLower.includes("your-command")) {
    return isPreEvent ? "Starting your operation" : "Your operation complete";
  }

  // For other tools
  if (tool === "YourTool" && descLower.includes("pattern")) {
    return isPreEvent ? "Pre phrase" : "Post phrase";
  }
}
```

### Adding New Tool Support

Add matcher to `config/claude-settings-hooks.json`:

```json
{
  "matcher": "^YourToolName$",
  "hooks": [
    {
      "type": "command",
      "command": "cc-voice",
      "args": []
    }
  ]
}
```

Then reinstall or manually merge into `~/.claude/settings.json`.

### Adding Platform-Specific Audio Players

Edit `bin/cc-voice`, locate the `play()` function:

```javascript
const tries = [
  `your-player "${file}"`,
  // Add to fallback chain
];
```

## Platform-Specific Notes

### Windows (Git Bash/WSL)
- `install.sh` runs in Git Bash or WSL
- PowerShell TTS used as fallback when no audio file player available
- Paths use Unix-style in script, but Windows paths work in Claude Code hooks
- Ensure `~/.local/bin` is in PATH or hooks won't find `cc-voice`

### macOS
- Native `afplay` and `say` commands provide best fallback experience
- `install.sh` will modify `~/.zshrc` or `~/.bashrc` for PATH and API keys
- Restart terminal after installation for environment variables to load

### Linux
- Requires `espeak`, `festival`, or similar TTS engine for fallback
- May need `ffplay` (from ffmpeg) or `aplay` for audio playback
- Some distributions require `sox` package for audio support

## Hook Event Structure

Claude Code sends JSON payloads to hook commands via stdin:

```json
{
  "hook_event_name": "PreToolUse" | "PostToolUse" | "Stop" | "SubagentStop" | "SessionEnd" | "Notification",
  "tool_name": "Edit" | "Write" | "Read" | "Bash" | "Grep" | "Glob" | "Task",
  "tool_input": {
    "description": "Human-readable description",
    "command": "bash command if Bash tool",
    "pattern": "search pattern if Grep/Glob",
    // ... other tool-specific params
  },
  "tool_response": {
    "output": "command output or tool result",
    "error": "error message if failed"
  }
}
```

The `cc-voice` script parses this to determine context and generate appropriate phrases.

## Important Files

- **`bin/cc-voice`** - Main voice script (modify for phrase/voice customization)
- **`config/claude-settings-hooks.json`** - Hook configuration template
- **`install.sh`** - Installer script (modify for new platforms)
- **`docs/VOICE-IDS.md`** - Complete ElevenLabs voice ID reference
- **`docs/demo.sh`** - Automated demo script showcasing features
- **`docs/interactive-demo.md`** - Step-by-step demo guide

## Testing Changes

After modifying `bin/cc-voice`:

1. **Test directly**: `node bin/cc-voice --phrase "Testing changes"`
2. **Test with payload**: `echo '{"hook_event_name":"PreToolUse",...}' | node bin/cc-voice`
3. **Reinstall**: `./install.sh` (or `cp bin/cc-voice ~/.local/bin/cc-voice`)
4. **Restart Claude Code**: Exit completely and relaunch
5. **Trigger operation**: Run a command that triggers the modified hook

## Troubleshooting

**No audio playing:**
- Check `cc-voice` is executable: `ls -la ~/.local/bin/cc-voice`
- Verify in PATH: `which cc-voice`
- Test manually: `cc-voice --phrase "test"`
- Check API key (if using ElevenLabs): `echo $ELEVENLABS_API_KEY`

**Wrong phrases playing:**
- Context detection may not match your command
- Add debug logging to `detectContext()` function
- Check tool_input.description matches expected pattern

**Hooks not triggering:**
- Verify `~/.claude/settings.json` has hooks configured
- Check matcher regex matches tool name exactly
- Restart Claude Code after settings changes
- Use `jq` to validate JSON: `cat ~/.claude/settings.json | jq`

**Installation issues:**
- On Windows: Run `install.sh` in Git Bash (not PowerShell/CMD)
- If `jq` missing: Manual merge required for existing settings
- PATH issues: Add `export PATH="$HOME/.local/bin:$PATH"` to shell profile
