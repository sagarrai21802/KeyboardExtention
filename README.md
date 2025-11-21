VoiceKeyboard Extension

⚠️ API Configuration (Required)

This project uses the Groq API. The API key is not included in the repository.

Create Secrets.swift inside the VoiceKeyboard folder:

```swift
import Foundation

struct Secrets {
    static let groqApiKey = "gsk_YOUR_ACTUAL_API_KEY_HERE"
}

Overview

VoiceKeyboard is a press-and-hold voice-to-text iOS keyboard extension. It records audio, converts it to text, and inserts the output at the cursor position. Built for fast input, visual clarity, and privacy-safe on-device processing.

⸻

Key Features
    •    Custom keyboard built with UIInputViewController
    •    Press-and-hold button
    •    Press → record
    •    Release → stop and transcribe
    •    Transcription via Apple Speech framework
    •    Text insertion using UITextDocumentProxy
    •    Light/Dark mode support
    •    Haptic + visual feedback
    •    Permission and failure-state handling

⸻

Setup
    1.    Install and run the main app target on a physical iPhone.
    2.    Open the host app for instructions/settings.
    3.    Enable Microphone permission.
    4.    Enable the keyboard:
Settings → General → Keyboard → Keyboards → Add New Keyboard → VoiceKeyboard
    5.    Enable Allow Full Access
    6.    Switch keyboards using the Globe icon.

⸻

Usage
    •    Press and hold the main button to record.
    •    Release to stop and trigger transcription.
    •    Processed text is inserted automatically at the cursor.

⸻

States

Idle → Recording → Processing → Completed
Haptics and visual indicators match each state.

⸻

Core Workflow
    1.    Start recording on press
    2.    Stop recording on release
    3.    Transcribe audio via SFSpeechRecognizer
    4.    Insert result text into active text field

⸻

Permissions

Add to Info.plist:

```swift
NSMicrophoneUsageDescription
Enable microphone to use voice keyboard

Enable Speech Recognition capability in Xcode.

⸻

Error Handling
    •    Missing microphone permission → onscreen guidance
    •    Speech failure → retry prompt
    •    Offline / network failure → keyboard remains responsive

⸻

Security
    •    Audio processed on-device only
    •    No permanent storage of recordings
    •    No external access without explicit press-and-hold input

⸻

Known Limitations
    •    No live streaming transcription
    •    Requires microphone permission
    •    Keyboard extension memory is limited
