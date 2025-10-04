# Contributing to JARVIS Voice

Thank you for your interest in contributing to JARVIS Voice! This document provides guidelines for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/jarvis-voice-claude.git`
3. Create a feature branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test thoroughly
6. Commit: `git commit -m 'Add amazing feature'`
7. Push: `git push origin feature/amazing-feature`
8. Open a Pull Request

## Development Setup

```bash
# Clone the repo
git clone https://github.com/yourusername/jarvis-voice-claude.git
cd jarvis-voice-claude

# Test the voice script
node bin/cc-voice --phrase "Testing development setup"

# Install locally for testing
./install.sh
```

## Code Style

- Use clear, descriptive variable names
- Comment complex logic
- Follow existing code patterns
- Keep functions focused and single-purpose

## Testing

Before submitting a PR:

1. Test on your platform (macOS/Linux/Windows)
2. Verify all voice announcements work
3. Test both with and without ElevenLabs API key
4. Check that hooks don't interfere with normal Claude Code operation

## Adding New Features

### New Voice Phrases

To add context-aware phrases, edit `bin/cc-voice`:

```javascript
// In detectContext() function
if (tool === "YourTool" && descLower.includes("your-pattern")) {
  return isPreEvent ? "Starting your operation" : "Your operation complete";
}
```

### New Tool Support

Add new tool matchers in `config/claude-settings-hooks.json`:

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

### Platform-Specific Audio

The `cc-voice` script has a playback fallback chain. To add support for new audio players:

```javascript
// In play() function
tries.push(`your-audio-player "${file}"`);
```

## Documentation

- Update README.md for user-facing changes
- Update docs/ for technical details
- Include examples in docs/interactive-demo.md
- Document new environment variables

## Commit Messages

Use clear, descriptive commit messages:

- `feat: Add support for new tool type`
- `fix: Resolve audio playback on Linux`
- `docs: Update installation instructions`
- `refactor: Simplify voice selection logic`

## Pull Request Process

1. Update documentation for any new features
2. Add your changes to a feature branch
3. Ensure no secrets or API keys are committed
4. Test on multiple platforms if possible
5. Describe your changes clearly in the PR description

## Bug Reports

When reporting bugs, include:

- OS and version
- Node.js version
- Claude Code version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs or error messages

## Feature Requests

Feature requests are welcome! Please:

- Check existing issues first
- Describe the use case
- Explain why it would be useful
- Consider backward compatibility

## Questions?

- Open a GitHub issue
- Tag it with `question`
- We'll respond as soon as possible

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

Thank you for contributing! 🎙️
