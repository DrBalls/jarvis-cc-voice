# ElevenLabs Voice IDs

This document lists available ElevenLabs voice IDs for customization.

## Default Configuration

The system uses these default voice IDs:

```bash
export ELEVENLABS_VOICE_ID="ZwQsH4li5bkOUTP3m3d1"  # Default voice (all events)
export ELEVENLABS_VOICE_ERROR="pNInz6obpgDQGcFmaJgB"  # Adam (serious tone for errors)
export ELEVENLABS_VOICE_ALERT="EXAVITQu4vr4xnSDxMaL"  # Bella (urgent tone for alerts)
```

## Available ElevenLabs Voices

You can use any of these voice IDs by setting the appropriate environment variables:

### Premium Voices

| Voice Name | Voice ID | Description |
|------------|----------|-------------|
| Rachel | `21m00Tcm4TlvDq8ikWAM` | Calm, clear female voice |
| Clyde | `2EiwWnXFnvU5JabPnv8n` | Strong, authoritative male voice |
| Domi | `AZnzlk1XvdvUeBnXmlld` | Energetic female voice |
| Dave | `CYw3kZ02Hs0563khs1Fj` | Conversational male voice |
| Fin | `D38z5RcWu1voky8WS1ja` | Friendly male voice |
| Bella | `EXAVITQu4vr4xnSDxMaL` | Clear, expressive female voice |
| Antoni | `ErXwobaYiN019PkySvjV` | Deep, professional male voice |
| Thomas | `GBv7mTt0atIp3Br8iCZE` | Mature male voice |
| Charlie | `IKne3meq5aSn9XLyUdCD` | Casual male voice |
| Emily | `LcfcDJNUP1GQjkzn1xUU` | Warm female voice |
| Elli | `MF3mGyEYCl7XYWbV9V6O` | Young, cheerful female voice |
| Callum | `N2lVS1w4EtoT3dr4eOWO` | British male voice |
| Patrick | `ODq5zmih8GrVes37Dizd` | Calm, soothing male voice |
| Harry | `SOYHLrjzK2X1ezoPC6cr` | Sophisticated male voice |
| Liam | `TX3LPaxmHKxFdv7VOQHJ` | Dynamic male voice |
| Dorothy | `ThT5KcBeYPX3keUQqHPh` | Classic female voice |
| Josh | `TxGEqnHWrfWFTfGW9XjX` | Versatile male voice |
| Arnold | `VR6AewLTigWG4xSOukaG` | Deep, commanding male voice |
| Charlotte | `XB0fDUnXU5powFXDhCwa` | Professional female voice |
| Alice | `Xb7hH8MSUJpSbSDYk0k2` | Gentle female voice |
| Matilda | `XrExE9yKIg1WjnnlVkGX` | Rich female voice |
| James | `ZQe5CZNOzWyzPSCn5a3c` | Authoritative male voice |
| Joseph | `Zlb1dXrM653N07WRdFW3` | Warm male voice |
| Jeremy | `bVMeCyTHy58xNoL34h3p` | Articulate male voice |
| Michael | `flq6f7yk4E4fJM5XTYuZ` | Resonant male voice |
| Ethan | `g5CIjZEefAph4nQFvHAz` | Clear male voice |
| Chris | `iP95p4xoKVk53GoZ742B` | Friendly male voice |
| Gigi | `jBpfuIE2acCO8z3wKNLl` | Playful female voice |
| Freya | `jsCqWAovK2LkecY7zXl4` | Nordic female voice |
| Daniel | `onwK4e9ZLuTAKqWW03F9` | Professional male voice |
| Lily | `pFZP5JQG7iQjIQuC4Bku` | Sweet female voice |
| Serena | `pMsXgVXv3BLzUgSXRplE` | Confident female voice |
| Adam | `pNInz6obpgDQGcFmaJgB` | Strong, serious male voice |
| Nicole | `piTKgcLEGmPE4e6mEKli` | Smooth female voice |
| Bill | `pqHfZKP75CvOlQylNhV4` | Mature male voice |
| Jessie | `t0jbNlBVZ17f02VDIeMI` | Casual female voice |
| Sam | `yoZ06aMxZJJ28mfd3POQ` | Versatile male voice |
| Glinda | `z9fAnlkpzviPz146aGWa` | Magical female voice |
| Giovanni | `zcAOhNBS3c14rBihAFp1` | Italian-accented male voice |
| Mimi | `zrHiDhphv9ZnVXBqCLjz` | Bright female voice |

## Customizing Voices per Event Type

You can set different voices for different event types:

```bash
# Success operations (PostToolUse)
export ELEVENLABS_VOICE_SUCCESS="21m00Tcm4TlvDq8ikWAM"  # Rachel

# Errors and failures
export ELEVENLABS_VOICE_ERROR="pNInz6obpgDQGcFmaJgB"  # Adam

# Pre-tool announcements
export ELEVENLABS_VOICE_PRE="ErXwobaYiN019PkySvjV"  # Antoni

# Alert notifications
export ELEVENLABS_VOICE_ALERT="EXAVITQu4vr4xnSDxMaL"  # Bella
```

## Testing Voices

Test a voice before using it:

```bash
export ELEVENLABS_API_KEY="your-key"
cc-voice --voice-id "21m00Tcm4TlvDq8ikWAM" --phrase "Testing voice"
```

## Voice Selection Logic

The `cc-voice` script selects voices in this order:

1. `--voice-id` command line argument (highest priority)
2. Context-specific environment variable:
   - `ELEVENLABS_VOICE_ERROR` for failures
   - `ELEVENLABS_VOICE_SUCCESS` for success
   - `ELEVENLABS_VOICE_PRE` for PreToolUse
   - `ELEVENLABS_VOICE_ALERT` for notifications
3. `ELEVENLABS_VOICE_ID` (default fallback)
4. Hardcoded default: `ZwQsH4li5bkOUTP3m3d1`

## Finding More Voices

Visit the [ElevenLabs Voice Library](https://elevenlabs.io/voice-library) to explore and clone additional voices.
