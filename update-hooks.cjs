#!/usr/bin/env node
// Update Claude Code hooks to use proper command for each platform

const fs = require('fs');
const os = require('os');
const path = require('path');

const homeDir = os.homedir();
const platform = os.platform();
const settingsPath = path.join(homeDir, '.claude', 'settings.json');

// Determine the correct command based on platform
let ccVoiceCommand;
let ccVoiceArgs;

if (platform === 'win32') {
  // Windows: use the .cmd wrapper
  ccVoiceCommand = path.join(homeDir, '.local', 'bin', 'cc-voice.cmd');
  ccVoiceArgs = [];
} else {
  // Unix-like: use node with the script path
  ccVoiceCommand = 'node';
  ccVoiceArgs = [path.join(homeDir, '.local', 'bin', 'cc-voice')];
}

const config = {
  hooks: {
    PreToolUse: [
      {
        matcher: '^(Edit|MultiEdit|Write)$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Bash$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Read$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^(Grep|Glob)$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Task$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      }
    ],
    PostToolUse: [
      {
        matcher: '^(Edit|MultiEdit|Write)$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Bash$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Read$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^(Grep|Glob)$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      },
      {
        matcher: '^Task$',
        hooks: [{ type: 'command', command: ccVoiceCommand, args: ccVoiceArgs }]
      }
    ],
    SessionEnd: [
      {
        hooks: [
          {
            type: 'command',
            command: ccVoiceCommand,
            args: [...ccVoiceArgs, '--phrase', 'Session ended. All systems offline.']
          }
        ]
      }
    ],
    Stop: [
      {
        hooks: [
          {
            type: 'command',
            command: ccVoiceCommand,
            args: [...ccVoiceArgs, '--phrase', 'Response cycle concluded. Awaiting further instruction.']
          }
        ]
      }
    ],
    SubagentStop: [
      {
        hooks: [
          {
            type: 'command',
            command: ccVoiceCommand,
            args: [...ccVoiceArgs, '--phrase', 'Auxiliary module has completed its assignment. Systems standing by.']
          }
        ]
      }
    ],
    Notification: [
      {
        hooks: [
          {
            type: 'command',
            command: ccVoiceCommand,
            args: [...ccVoiceArgs, '--phrase', 'Your immediate attention is required. A situation awaits your command.']
          }
        ]
      }
    ]
  }
};

// Read existing settings
const settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));

// Merge hooks
const merged = { ...settings, hooks: config.hooks };

// Write back
fs.writeFileSync(settingsPath, JSON.stringify(merged, null, 2));

console.log('✓ Updated hooks to use: ' + ccVoiceCommand + (ccVoiceArgs.length ? ' ' + ccVoiceArgs.join(' ') : ''));
console.log('✓ Settings saved to: ' + settingsPath);
console.log('\nRestart Claude Code to activate the changes.');
