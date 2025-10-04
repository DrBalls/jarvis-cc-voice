#!/bin/bash
# JARVIS Voice System - Installation Script
# Cross-platform installer for macOS, Linux, and Windows (Git Bash/WSL)

set -e

# Get the script directory (absolute path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify we're in the correct directory
if [ ! -f "$SCRIPT_DIR/bin/cc-voice" ]; then
    echo "❌ Error: Could not find bin/cc-voice"
    echo "   Please run this script from the JARVIS Voice repository root"
    exit 1
fi

echo "🎙️  JARVIS Voice System Installer"
echo "=================================="
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "Detected OS: $OS"
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is required but not installed."
    echo "   Please install Node.js from https://nodejs.org"
    exit 1
fi

echo "✓ Node.js found: $(node --version)"
echo ""

# Determine installation directory
INSTALL_DIR="${HOME}/.local/bin"
mkdir -p "$INSTALL_DIR"

# Copy cc-voice script
echo "📦 Installing cc-voice script..."
cp "$SCRIPT_DIR/bin/cc-voice" "$INSTALL_DIR/cc-voice"
chmod +x "$INSTALL_DIR/cc-voice"

# On Windows, also create a .cmd wrapper for proper stdin handling
if [[ "$OS" == "windows" ]]; then
    cat > "$INSTALL_DIR/cc-voice.cmd" << 'CMDEOF'
@echo off
REM JARVIS Voice System - Windows wrapper for cc-voice
node "%~dp0cc-voice" %*
CMDEOF
    echo "✓ Installed to: $INSTALL_DIR/cc-voice and cc-voice.cmd"
else
    echo "✓ Installed to: $INSTALL_DIR/cc-voice"
fi
echo ""

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "⚠️  Warning: $INSTALL_DIR is not in your PATH"
    echo "   Add this line to your ~/.zshrc or ~/.bashrc:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Setup Claude Code settings
CLAUDE_SETTINGS_DIR="${HOME}/.claude"
CLAUDE_SETTINGS_FILE="${CLAUDE_SETTINGS_DIR}/settings.json"

mkdir -p "$CLAUDE_SETTINGS_DIR"

# Check if settings file exists
if [ -f "$CLAUDE_SETTINGS_FILE" ]; then
    echo "📝 Existing Claude settings found"
    echo "   Backing up to: ${CLAUDE_SETTINGS_FILE}.backup"
    cp "$CLAUDE_SETTINGS_FILE" "${CLAUDE_SETTINGS_FILE}.backup"
    echo ""

    # Check if hooks already exist
    if grep -q '"hooks"' "$CLAUDE_SETTINGS_FILE"; then
        echo "⚠️  Hooks already exist in your settings!"
        echo "   Manual merge required. Your hooks config template is in:"
        echo "   $SCRIPT_DIR/config/claude-settings-hooks.json"
        echo ""
        echo "   Backup saved at: ${CLAUDE_SETTINGS_FILE}.backup"
        echo ""
    else
        echo "🔧 Merging hooks into existing settings..."
        # Use node to update settings (works on all platforms)
        if command -v node &> /dev/null; then
            node "$SCRIPT_DIR/update-hooks.cjs"
            echo "✓ Hooks merged successfully with platform-compatible paths"
        else
            # Fallback to jq if node not available
            if command -v jq &> /dev/null; then
                jq -s '.[0] * .[1]' "$CLAUDE_SETTINGS_FILE" "$SCRIPT_DIR/config/claude-settings-hooks.json" > "${CLAUDE_SETTINGS_FILE}.tmp"
                mv "${CLAUDE_SETTINGS_FILE}.tmp" "$CLAUDE_SETTINGS_FILE"
                echo "✓ Hooks merged (may need manual path updates on Windows)"
            else
                echo "⚠️  Neither node nor jq found - manual merge required"
                echo "   Run: node $SCRIPT_DIR/update-hooks.cjs"
                echo "   Or copy hooks from: $SCRIPT_DIR/config/claude-settings-hooks.json"
            fi
        fi
        echo ""
    fi
else
    echo "📝 Creating new Claude settings with hooks..."

    # Use node to create settings with proper paths
    if command -v node &> /dev/null; then
        node "$SCRIPT_DIR/update-hooks.cjs"
        echo "✓ Settings created at: $CLAUDE_SETTINGS_FILE"
    else
        # Fallback to direct copy if node not available
        cp "$SCRIPT_DIR/config/claude-settings-hooks.json" "$CLAUDE_SETTINGS_FILE"
        echo "⚠️  Settings created, but may need manual path updates on Windows"
        echo "   Run: node $SCRIPT_DIR/update-hooks.cjs"
    fi
    echo ""
fi

# Optional: ElevenLabs setup
echo "🔊 Voice Configuration"
echo "----------------------"
echo ""
echo "JARVIS supports multiple voice options:"
echo ""
case "$OS" in
    macos)
        echo "1. System TTS (macOS 'say' command) - Free, works out of the box"
        ;;
    linux)
        echo "1. System TTS (espeak/festival) - Free, install with: sudo apt-get install espeak"
        ;;
    windows)
        echo "1. System TTS (PowerShell) - Free, built-in on Windows"
        ;;
esac
echo "2. ElevenLabs AI Voices - Premium quality, requires API key"
echo ""

read -p "Do you have an ElevenLabs API key? (y/N): " has_key

if [[ "$has_key" =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Enter your ElevenLabs API key: " api_key

    # On Windows, update the .cmd wrapper with API key
    if [[ "$OS" == "windows" ]]; then
        cat > "$INSTALL_DIR/cc-voice.cmd" << CMDEOF
@echo off
REM JARVIS Voice System - Windows wrapper for cc-voice

REM Set ElevenLabs environment variables
set ELEVENLABS_API_KEY=$api_key
set ELEVENLABS_VOICE_ID=ZwQsH4li5bkOUTP3m3d1
set ELEVENLABS_MODEL_ID=eleven_flash_v2_5

REM Run cc-voice with the environment variables set
node "%~dp0cc-voice" %*
CMDEOF
        echo "✓ ElevenLabs config added to cc-voice.cmd"
        echo ""
    fi

    # Add to shell profile (for macOS/Linux, and for bash sessions on Windows)
    SHELL_PROFILE=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    fi

    if [ -n "$SHELL_PROFILE" ]; then
        echo "" >> "$SHELL_PROFILE"
        echo "# JARVIS Voice System - ElevenLabs Configuration" >> "$SHELL_PROFILE"
        echo "export ELEVENLABS_API_KEY=\"$api_key\"" >> "$SHELL_PROFILE"
        echo "export ELEVENLABS_VOICE_ID=\"ZwQsH4li5bkOUTP3m3d1\"  # Default voice" >> "$SHELL_PROFILE"
        echo "export ELEVENLABS_MODEL_ID=\"eleven_flash_v2_5\"" >> "$SHELL_PROFILE"
        echo "" >> "$SHELL_PROFILE"

        if [[ "$OS" == "windows" ]]; then
            echo "✓ ElevenLabs config also added to $SHELL_PROFILE (for bash sessions)"
        else
            echo "✓ ElevenLabs config added to $SHELL_PROFILE"
            echo "  Run: source $SHELL_PROFILE"
        fi
        echo ""
    else
        echo "⚠️  Could not find shell profile"
        echo "   Manually add these to your shell profile:"
        echo "   export ELEVENLABS_API_KEY=\"$api_key\""
        echo "   export ELEVENLABS_VOICE_ID=\"ZwQsH4li5bkOUTP3m3d1\""
        echo ""
    fi
else
    case "$OS" in
        macos)
            echo "✓ Using system TTS (macOS 'say' command)"
            ;;
        linux)
            echo "✓ Using system TTS (install espeak if needed)"
            ;;
        windows)
            echo "✓ Using system TTS (PowerShell)"
            ;;
    esac
    echo ""
fi

echo "✅ Installation Complete!"
echo "========================="
echo ""
echo "Next steps:"
echo "1. Restart Claude Code (completely exit and relaunch)"
echo "2. Try editing a file to hear voice announcements"
echo "3. See docs/interactive-demo.md for full feature demo"
echo ""
echo "Configuration files:"
echo "  • Voice script: $INSTALL_DIR/cc-voice"
echo "  • Claude settings: $CLAUDE_SETTINGS_FILE"
echo ""
echo "To customize voices or phrases, edit: $INSTALL_DIR/cc-voice"
echo ""
echo "🎙️  JARVIS is ready to assist you!"
