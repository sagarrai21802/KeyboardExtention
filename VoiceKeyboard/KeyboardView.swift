//
//  KeyboardView.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import SwiftUI
import Speech

struct KeyboardView: View {
    
    // Callback to insert text back into host app
    var insertText: (String) -> Void
    
    @StateObject private var recorder = AudioRecorder() // Audio recorder instance
    @State private var isProcessing = false              // Track transcription process
    private let transcriber = SpeechTranscriber()       // Handles transcription
    
    var body: some View {
        ZStack {
            
            // MARK: - Background
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // MARK: - Status text
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: - Main mic button with pulse
                ZStack {
                    
                    // Pulse effect when recording
                    if recorder.isRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.5), lineWidth: 4)
                            .frame(width: 80, height: 80)
                            .scaleEffect(1.2)
                            .animation(
                                .easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true),
                                value: recorder.isRecording
                            )
                    }
                    
                    // Button circle
                    Circle()
                        .fill(buttonColor)
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: iconName)
                                .font(.title)
                                .foregroundColor(.white)
                        )
                }
                
                // MARK: - Gesture: Press and Hold
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !recorder.isRecording && !isProcessing {
                                startRecording()
                            }
                        }
                        .onEnded { _ in
                            if recorder.isRecording {
                                stopAndTranscribe()
                            }
                        }
                )
            } // VStack
        } // ZStack
    }
    
    // MARK: - Recording Logic
    
    private func startRecording() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()  // Haptic feedback
        recorder.startRecording()   // Begin recording audio
    }
    
    private func stopAndTranscribe() {
        guard let url = recorder.stopRecording() else { return }
        
        isProcessing = true
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()  // Haptic feedback
        
        // Transcribe audio
        transcriber.transcribeFile(at: url) { result in
            DispatchQueue.main.async {
                isProcessing = false
                switch result {
                case .success(let text):
                    insertText(text + " ") // Send back with trailing space
                case .failure(let error):
                    insertText("[Error: \(error.localizedDescription)]")
                }
            }
        }
    }
    
    // MARK: - UI Helpers
    
    var statusMessage: String {
        if recorder.isRecording { return "Listening..." }
        if isProcessing { return "Transcribing..." }
        return "Hold to Speak"
    }
    
    var buttonColor: Color {
        if recorder.isRecording { return .red }
        if isProcessing { return .gray }
        return .blue
    }
    
    var iconName: String {
        if isProcessing { return "hourglass" }
        return "mic.fill"
    }
}
