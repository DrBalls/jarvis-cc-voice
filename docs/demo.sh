#!/bin/bash
# JARVIS Voice Demo Script
# Demonstrates all the cool voice announcements

set -e

echo "🎙️  JARVIS Voice System Demo"
echo "================================"
echo ""
echo "This demo will trigger various Claude Code operations"
echo "to showcase the voice announcement system."
echo ""
echo "Make sure you're running this inside a Claude Code session!"
echo ""
read -p "Press Enter to start the demo..."

# Create demo directory
DEMO_DIR="/tmp/jarvis-demo-$$"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

echo ""
echo "📝 Demo 1: File Operations"
echo "----------------------------"
echo "Creating and editing files..."
sleep 2

# This will be done by Claude to trigger the hooks
cat > demo-file.txt << EOF
This is a test file for JARVIS voice demo
EOF

echo "✓ File created"
sleep 2

echo ""
echo "📖 Demo 2: Reading Files"
echo "----------------------------"
echo "Reading a file (ask Claude to read demo-file.txt)"
sleep 2

echo ""
echo "🔍 Demo 3: Search Operations"
echo "----------------------------"
echo "Searching for patterns (ask Claude to grep for 'test')"
sleep 2

echo ""
echo "🔧 Demo 4: Command Execution"
echo "----------------------------"
echo "Running a simple command..."
sleep 1
echo "Hello from JARVIS!" > command-output.txt
cat command-output.txt
sleep 2

echo ""
echo "🧪 Demo 5: Test Execution (Simulated)"
echo "----------------------------"
echo "Simulating test output..."
sleep 1
cat > test-output.txt << EOF
Running tests...
✓ Test 1 passed
✓ Test 2 passed
✓ Test 3 passed

All tests passed!
EOF
cat test-output.txt
sleep 2

echo ""
echo "🔨 Demo 6: Build Operation (Simulated)"
echo "----------------------------"
echo "Simulating build output..."
sleep 1
cat > build-output.txt << EOF
Building project...
Compiling sources...
Linking...
Build completed successfully!
EOF
cat build-output.txt
sleep 2

echo ""
echo "🔨 Demo 7: Build Failure (Simulated)"
echo "----------------------------"
echo "Simulating failed build..."
sleep 1
cat > build-error.txt << EOF
Building project...
Compiling sources...
ERROR: syntax error on line 42
Build failed
EOF
cat build-error.txt
sleep 2

echo ""
echo "📦 Demo 8: Git Operations"
echo "----------------------------"
echo "Setting up a git repository..."
git init
git config user.email "demo@jarvis.ai"
git config user.name "JARVIS Demo"
echo "Repository initialized" > README.md
git add README.md
echo "Committing (this should trigger git commit voice)..."
sleep 1
git commit -m "Initial commit"
sleep 2

echo ""
echo "🎯 Demo Complete!"
echo "================================"
echo ""
echo "You should have heard various announcements:"
echo "  • Initiating/completing file operations"
echo "  • Executing commands"
echo "  • Test results"
echo "  • Build success/failure"
echo "  • Git operations"
echo ""
echo "To trigger more announcements, ask Claude to:"
echo "  - Edit files (you'll hear: 'Initiating Edit operation')"
echo "  - Read files (you'll hear: 'Retrieving file contents')"
echo "  - Run git commands (you'll hear context-specific phrases)"
echo "  - Run tests or builds (you'll hear result-based phrases)"
echo ""
echo "Cleaning up demo directory..."
cd /
rm -rf "$DEMO_DIR"
echo "✓ Cleanup complete"
echo ""
echo "🎙️  JARVIS is ready to assist you!"
