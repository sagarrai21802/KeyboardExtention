

//
//  KeyboardView.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import SwiftUI

struct KeyboardView: View {
    
    // Callback to insert text back into host app
    var insertText: (String) -> Void
    
    @StateObject private var recorder = AudioRecorder()
    @State private var isProcessing = false
    
    // CHANGED: Use GroqClient instead of SpeechTranscriber
    private let client = GroqClient()
    
    var body: some View {
        ZStack {
            
            // Background
            Color(UIColor.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // Status text
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Main mic button
                ZStack {
                    // Pulse effect
                    if recorder.isRecording {
                        Circle()
                            .stroke(Color.red.opacity(0.5), lineWidth: 4)
                            .frame(width: 80, height: 80)
                            .scaleEffect(1.2)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: recorder.isRecording)
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
                // Gesture
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
            }
        }
    }
    
    // MARK: - Logic
    
    private func startRecording() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        recorder.startRecording()
    }
    
    private func stopAndTranscribe() {
        guard let url = recorder.stopRecording() else { return }
        
        isProcessing = true
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        // CHANGED: Call Groq API
        client.transcribe(audioURL: url) { result in
            DispatchQueue.main.async {
                isProcessing = false
                switch result {
                case .success(let text):
                    insertText(text + " ")
                case .failure(let error):
                    insertText("[Error: \(error.localizedDescription)]")
                }
            }
        }
    }
    
    // MARK: - UI Helpers
    
    var statusMessage: String {
        if recorder.isRecording { return "Listening..." }
        if isProcessing { return "Transcribing with Groq..." }
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
