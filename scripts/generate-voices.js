#!/usr/bin/env node
// Generate all voice announcement variations for bundling with the installer

import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { execSync } from "node:child_process";

const ELEVENLABS_API_KEY = process.env.ELEVENLABS_API_KEY;
const ELEVENLABS_VOICE_ID = process.env.ELEVENLABS_VOICE_ID || "ZwQsH4li5bkOUTP3m3d1";
const ELEVENLABS_MODEL_ID = process.env.ELEVENLABS_MODEL_ID || "eleven_flash_v2_5";

// Voice IDs for different contexts
const VOICE_SUCCESS = process.env.ELEVENLABS_VOICE_SUCCESS || ELEVENLABS_VOICE_ID;
const VOICE_ERROR = process.env.ELEVENLABS_VOICE_ERROR || "pNInz6obpgDQGcFmaJgB"; // Adam
const VOICE_PRE = process.env.ELEVENLABS_VOICE_PRE || ELEVENLABS_VOICE_ID;
const VOICE_ALERT = process.env.ELEVENLABS_VOICE_ALERT || "EXAVITQu4vr4xnSDxMaL"; // Bella

if (!ELEVENLABS_API_KEY) {
  console.error("❌ Error: ELEVENLABS_API_KEY environment variable required");
  console.error("   Set with: export ELEVENLABS_API_KEY='your-key'");
  process.exit(1);
}

// All phrases to generate, organized by voice type
const PHRASES = {
  // Default voice (success operations)
  success: [
    // Tool completions
    "File modified successfully",
    "File created successfully",
    "File retrieved and analyzed",
    "Command executed successfully",
    "Search complete",
    "Agent task completed",

    // Git operations
    "Code committed to repository",
    "Changes pushed to remote",
    "Repository synchronized",
    "Repository query complete",
    "Changes staged",

    // Tests/builds
    "Test suite execution complete. All tests passed",
    "Build completed successfully",

    // Package manager
    "Dependencies installed",
    "Server started",
    "dev script complete",
    "build script complete",
    "start script complete",
    "test script complete",

    // Directory operations
    "Directory identified",
    "Directory changed",
    "Directory listing complete",
    "Directory created",

    // File operations
    "File read complete",
    "File copied",
    "File moved",
    "File removed",
    "File created",

    // Search operations
    "File search complete",

    // Process operations
    "Process list retrieved",
    "Process terminated",

    // Network operations
    "Resource fetched",
    "Network test complete",

    // System info
    "Command located",
    "Environment retrieved",
    "Permissions updated",

    // Docker operations
    "Docker build complete",
    "Docker run complete",
    "Docker start complete",
    "Docker stop complete",
    "Docker ps complete",
    "Docker exec complete",
  ],

  // Pre-event voice
  pre: [
    // Tool initiations
    "Initiating Edit operation",
    "Initiating MultiEdit operation",
    "Initiating Write operation",
    "Retrieving file contents",
    "Executing command",
    "Searching codebase",
    "Launching specialized agent",

    // Git operations
    "Committing changes to repository",
    "Pushing to remote repository",
    "Pulling from remote repository",
    "Querying repository status",
    "Staging changes",

    // Tests/builds
    "Initiating test suite execution",
    "Initiating build process",

    // Package manager
    "Installing dependencies",
    "Starting development server",
    "Running dev script",
    "Running build script",
    "Running start script",
    "Running test script",

    // Directory operations
    "Checking current directory",
    "Changing directory",
    "Listing directory contents",
    "Creating directory",

    // File operations
    "Reading file",
    "Copying file",
    "Moving file",
    "Removing file",
    "Creating file",

    // Search operations
    "Searching files",
    "Searching for files",

    // Process operations
    "Checking processes",
    "Terminating process",

    // Network operations
    "Fetching remote resource",
    "Testing network connection",

    // System info
    "Locating command",
    "Checking environment variables",
    "Modifying permissions",

    // Docker operations
    "Docker build initiating",
    "Docker run initiating",
    "Docker start initiating",
    "Docker stop initiating",
    "Docker ps initiating",
    "Docker exec initiating",
  ],

  // Error voice (failures)
  error: [
    "Test suite execution complete. Failures detected",
    "Build failed. Review errors",
  ],

  // Alert voice (notifications)
  alert: [
    "Response cycle concluded. Awaiting further instruction.",
    "Auxiliary module has completed its assignment. Systems standing by.",
  ]
};

const OUTPUT_DIR = path.join(process.cwd(), "voices");

async function fetchTTS(phrase, voiceId, modelId) {
  const url = `https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`;
  const body = {
    text: phrase,
    model_id: modelId,
  };

  const resp = await fetch(url, {
    method: "POST",
    headers: {
      "xi-api-key": ELEVENLABS_API_KEY,
      "Content-Type": "application/json",
      "Accept": "audio/mpeg"
    },
    body: JSON.stringify(body)
  });

  if (!resp.ok) {
    throw new Error(`ElevenLabs HTTP ${resp.status}: ${await resp.text()}`);
  }

  return Buffer.from(await resp.arrayBuffer());
}

function getCacheKey(text, voice, model) {
  return crypto.createHash("sha1").update([text, voice, model].join("|")).digest("hex");
}

async function generateVoices() {
  console.log("🎙️  JARVIS Voice Generator");
  console.log("========================\n");

  // Create output directory
  fs.mkdirSync(OUTPUT_DIR, { recursive: true });

  let totalGenerated = 0;
  let totalSkipped = 0;

  for (const [voiceType, phrases] of Object.entries(PHRASES)) {
    let voiceId;
    switch (voiceType) {
      case 'success': voiceId = VOICE_SUCCESS; break;
      case 'pre': voiceId = VOICE_PRE; break;
      case 'error': voiceId = VOICE_ERROR; break;
      case 'alert': voiceId = VOICE_ALERT; break;
    }

    console.log(`\n📢 Generating ${voiceType} phrases (voice: ${voiceId})...\n`);

    for (const phrase of phrases) {
      const cacheKey = getCacheKey(phrase, voiceId, ELEVENLABS_MODEL_ID);
      const outputPath = path.join(OUTPUT_DIR, `${cacheKey}.mp3`);

      // Skip if already exists
      if (fs.existsSync(outputPath)) {
        console.log(`   ⏭️  Skip: "${phrase}"`);
        totalSkipped++;
        continue;
      }

      try {
        console.log(`   🎤 Generate: "${phrase}"`);
        const audio = await fetchTTS(phrase, voiceId, ELEVENLABS_MODEL_ID);
        fs.writeFileSync(outputPath, audio);
        console.log(`   ✅ Saved: ${cacheKey}.mp3`);
        totalGenerated++;

        // Small delay to avoid rate limiting
        await new Promise(resolve => setTimeout(resolve, 500));
      } catch (error) {
        console.error(`   ❌ Error: ${error.message}`);
      }
    }
  }

  // Create manifest file
  const manifest = {
    generated_at: new Date().toISOString(),
    voice_ids: {
      success: VOICE_SUCCESS,
      pre: VOICE_PRE,
      error: VOICE_ERROR,
      alert: VOICE_ALERT,
    },
    model_id: ELEVENLABS_MODEL_ID,
    total_files: totalGenerated + totalSkipped,
    phrases: PHRASES,
  };

  fs.writeFileSync(
    path.join(OUTPUT_DIR, "manifest.json"),
    JSON.stringify(manifest, null, 2)
  );

  console.log("\n========================");
  console.log(`✅ Generation Complete!`);
  console.log(`   Generated: ${totalGenerated} files`);
  console.log(`   Skipped: ${totalSkipped} files`);
  console.log(`   Total: ${totalGenerated + totalSkipped} files`);
  console.log(`   Output: ${OUTPUT_DIR}`);
  console.log("\n📄 Manifest saved: voices/manifest.json");
}

generateVoices().catch(console.error);
