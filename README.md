# 🎙️ JARVIS Voice System for Claude Code

An intelligent voice notification system that provides real-time audio feedback for Claude Code operations, with context-aware phrases and dynamic voice selection.

**Cross-platform support**: macOS, Linux, and Windows

## ⚡ Quick Start

```bash
git clone https://github.com/yourusername/jarvis-voice-claude.git
cd jarvis-cc-voice
./install.sh
```

Restart Claude Code and start coding with voice feedback!

## 📋 Requirements

- **Node.js** (v16 or higher)
- **Claude Code** (latest version)
- **Optional**: ElevenLabs API key for premium AI voices (falls back to system TTS)

## 🚀 Installation

### Automatic Installation (Recommended)

```bash
./install.sh
```

The installer will:
1. Install the `cc-voice` script to `~/.local/bin`
2. Configure Claude Code hooks in `~/.claude/settings.json`
3. Optionally set up ElevenLabs API key
4. Create a backup of existing settings

### Manual Installation

1. Copy the voice script:
   ```bash
   cp bin/cc-voice ~/.local/bin/cc-voice
   chmod +x ~/.local/bin/cc-voice
   ```

2. Add hooks to your `~/.claude/settings.json`:
   ```bash
   # If file doesn't exist:
   cp config/claude-settings-hooks.json ~/.claude/settings.json

   # If file exists, merge the "hooks" section from:
   # config/claude-settings-hooks.json
   ```

3. Restart Claude Code

## Features

### 1. Tool-Specific Phrases
Different announcements for each tool type:
- **Edit/Write**: "Initiating Edit operation" → "File modified successfully"
- **Read**: "Retrieving file contents" → "File retrieved and analyzed"
- **Bash**: "Executing command" → "Command executed successfully"
- **Grep/Glob**: "Searching codebase" → "Search complete"
- **Task**: "Launching specialized agent" → "Agent task completed"

### 2. Smart Context Detection
Automatically detects and announces specific operations:

#### Git Operations
- `git commit` → "Committing changes to repository" → "Code committed to repository"
- `git push` → "Pushing to remote repository" → "Changes pushed to remote"
- `git pull` → "Pulling from remote repository" → "Repository synchronized"

#### Test Execution
- Detects test commands (npm test, pytest, jest, etc.)
- "Initiating test suite execution"
- Analyzes output: "All tests passed" or "Failures detected"

#### Build Operations
- Detects build commands (npm run build, cargo build, etc.)
- "Initiating build process"
- Analyzes output: "Build completed successfully" or "Build failed. Review errors"

### 3. PreToolUse Announcements
Hear what's about to happen before it executes, giving you awareness of Claude's actions in real-time.

### 4. Dynamic Voice Selection
Different ElevenLabs voices for different contexts:
- **Success operations**: Default confident voice
- **Errors/Failures**: Serious tone (Adam voice)
- **Alerts/Notifications**: Urgent tone (Bella voice)
- **PreToolUse**: Slightly different for variety

Customize voices via environment variables:
```bash
export ELEVENLABS_VOICE_SUCCESS="your-voice-id"
export ELEVENLABS_VOICE_ERROR="your-voice-id"
export ELEVENLABS_VOICE_PRE="your-voice-id"
export ELEVENLABS_VOICE_ALERT="your-voice-id"
```

### 5. Intelligent Caching
Audio files are cached locally for instant playback of repeated phrases, reducing API calls and latency.

## Configuration

Your hooks are configured in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "^(Edit|MultiEdit|Write)$", "hooks": [...] },
      { "matcher": "^Bash$", "hooks": [...] },
      { "matcher": "^Read$", "hooks": [...] },
      { "matcher": "^(Grep|Glob)$", "hooks": [...] },
      { "matcher": "^Task$", "hooks": [...] }
    ],
    "PostToolUse": [
      // Same matchers as PreToolUse
    ],
    "Stop": [...],
    "SubagentStop": [...],
    "Notification": [...]
  }
}
```

## Voice Script Location

`~/.local/bin/cc-voice`

The script automatically:
- Reads hook event payloads via stdin
- Detects tool name, description, and command context
- Analyzes tool output for success/failure indicators
- Selects appropriate voice based on context
- Caches generated audio for performance
- Falls back to system TTS if ElevenLabs unavailable

## Demo Script

Run `./demo.sh` to hear all the different voice announcements in action!

## Requirements

- Claude Code
- Node.js (for cc-voice script)
- ElevenLabs API key (optional, falls back to macOS `say` command)
- macOS (for `afplay` and `say` commands)

## Environment Variables

```bash
# ElevenLabs Configuration
export ELEVENLABS_API_KEY="your-api-key"
export ELEVENLABS_VOICE_ID="ZwQsH4li5bkOUTP3m3d1"  # Default voice
export ELEVENLABS_MODEL_ID="eleven_flash_v2_5"

# Voice Overrides
export ELEVENLABS_VOICE_SUCCESS="voice-id-for-success"
export ELEVENLABS_VOICE_ERROR="voice-id-for-errors"
export ELEVENLABS_VOICE_PRE="voice-id-for-pre-events"
export ELEVENLABS_VOICE_ALERT="voice-id-for-alerts"

# Playback Configuration
export CC_VOICE_PLAYER="afplay"  # or "say", "ffplay", "pwsh"
```

## Supported Event Types

- **PreToolUse**: Before any tool executes
- **PostToolUse**: After any tool completes
- **Stop**: When Claude stops generating
- **SubagentStop**: When a specialized agent completes
- **SessionEnd**: When you exit Claude
- **Notification**: System notifications

## Examples

### File Operations
```
"Initiating Edit operation"
[file is being edited]
"File modified successfully"
```

### Git Workflow
```
"Committing changes to repository"
[commit happens]
"Code committed to repository"
```

### Test Execution
```
"Initiating test suite execution"
[tests run]
"Test suite execution complete. All tests passed"
```

### Build with Failure
```
"Initiating build process"
[build runs and fails]
"Build failed. Review errors"
```

## Troubleshooting

**No sound playing?**
- Check that `cc-voice` is executable: `chmod +x ~/.local/bin/cc-voice`
- Verify ElevenLabs API key is set (or macOS `say` command works)
- Check cache directory exists: `ls /tmp/cc-voice-cache`

**Hearing generic phrases instead of specific ones?**
- Restart Claude completely (exit terminal and relaunch)
- Verify settings.json syntax is correct: `cat ~/.claude/settings.json | jq`

**Want to customize phrases?**
- Edit `~/.local/bin/cc-voice` and modify the `getToolPhrase()` or `detectContext()` functions

## Credits

Built with ❤️ for an enhanced Claude Code experience.
