VoiceKeyboard — Press-and-Hold Voice-to-Text Keyboard (iOS)

VoiceKeyboard is a custom iOS keyboard extension that allows users to record voice using a press-and-hold gesture and converts the audio to text using Apple’s Speech framework. The resulting text is inserted at the current cursor position. It is designed to be simple, responsive, and provide clear visual and haptic feedback.

Features
	•	Custom keyboard built on UIInputViewController.
	•	Single prominent button with press-and-hold gesture:
	•	Starts recording on press.
	•	Stops recording on release and processes audio.
	•	Transcription using Apple Speech framework (no external API required).
	•	Inserts text via UITextDocumentProxy.
	•	Visual feedback for recording, processing, and completion.
	•	Haptic feedback for button states.
	•	Light/Dark mode support.
	•	Error handling for missing permissions or transcription failures.

Demo
	1.	Enable the keyboard in Settings > Keyboards > Add New Keyboard > VoiceKeyboard.
	2.	Switch to the keyboard in any text field.
	3.	Press and hold the main button to start recording.
	4.	Release to stop recording and process transcription.
	5.	Transcribed text appears at the cursor.
	6.	Errors display meaningful feedback with retry options.

Project Structure
	•	Main App Target: Optional host app for instructions, permissions, and API key configuration (if needed in future).
	•	Keyboard Extension: Handles UI, audio recording, transcription, and text insertion.
	•	Shared Utilities: Optional Keychain wrapper for securely storing keys or other secrets.

Core Workflow
	1.	Idle: Displays a single prominent button.
	2.	Press-and-Hold: Starts AVAudioRecorder, updates UI, triggers haptic feedback.
	3.	Release: Stops recorder and finalizes audio file.
	4.	Transcription: Uses Apple’s SFSpeechRecognizer to convert audio to text.
	5.	Insert Text: Inserts the transcribed text using textDocumentProxy.insertText(_).

Note: No real-time transcription; audio is processed only after recording completes.

Setup
	1.	Add Microphone Permission in Info.plist:
  <key>NSMicrophoneUsageDescription</key>
  <string>Enable microphone to use voice keyboard</string>

2.	Enable Speech Recognition in Xcode Capabilities.
	3.	Run on a physical device (simulator does not support audio input).

UI & Interaction
	•	Single button with states:
	•	Idle → Normal
	•	Pressed → Recording
	•	Released → Processing
	•	Complete → Confirmation
	•	Haptic feedback using UIImpactFeedbackGenerator.
	•	Supports Light/Dark mode and keyboard height constraints.

Error Handling
	•	No microphone permission → shows guidance to enable access.
	•	Speech recognition denied → provides retry option.
	•	Network or processing errors → displays message, keyboard remains responsive.

Testing
	•	Record → Release → Transcribe → Insert text.
	•	Test edge cases: short tap, long press, no mic permission, offline mode.
	•	Test on iPhone and iPad devices.

Security & Privacy
	•	Audio processed entirely on-device.
	•	No external API usage.
	•	No permanent storage of audio files.
	•	Keyboard extensions cannot capture data without explicit user interaction.

Known Limitations
	•	No real-time transcription.
	•	Requires microphone access.
	•	Limited memory in keyboard extension; large audio buffers avoided.

Acknowledgments
	•	Apple Speech framework
	•	AVFoundation
	•	UIKit

  
