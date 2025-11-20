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

Step-by-Step Procedure for Using VoiceKeyboard
1.	Install the App
	•	Run the main app target on your iPhone.
	•	The app installs along with the VoiceKeyboard keyboard extension.

2.	Open the App
	•	Launch the host app to access instructions and settings.
	•	You will see options to configure Microphone Permission, Keyboard Settings, and Full Access.

3.	Enable Microphone Permission
	•	Tap the option to go to Settings → Privacy → Microphone.
	•	Enable microphone access for VoiceKeyboard.

4.	Enable Keyboard and Full Access
	•	Go to Settings → General → Keyboard → Keyboards → Add New Keyboard.
	•	Select VoiceKeyboard.
	•	Enable Allow Full Access for enhanced functionality.

5.	Switch to VoiceKeyboard
	•	Open any app with a text field (Messages, Notes, etc.).
	•	Tap the Globe icon on the default keyboard to switch to VoiceKeyboard.

6.	Permissions Prompt
	•	On the first use, an alert appears asking for microphone and speech recognition permissions.
	•	Grant permission to proceed.

7.	Use Press-and-Hold Gesture
	•	Press and hold the main button to start recording your voice.
	•	Release the button to stop recording.
	•	The app processes the audio and converts it to text using Apple’s SFSpeechRecognizer.

8.	Text Insertion
	•	The transcribed text is automatically inserted at the current cursor position in the text field.

9.	Feedback
	•	Visual feedback shows recording, processing, and completion states.
	•	Haptic feedback confirms button press, release, and completion.

10.	Error Handling
	•	If microphone permission is denied, the keyboard shows guidance to enable it.
	•	If speech recognition fails, a retry option is displayed.
	•	Keyboard remains responsive even in offline or error conditions.


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

  
