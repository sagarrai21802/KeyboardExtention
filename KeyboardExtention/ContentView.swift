//
//  ContentView.swift
//  KeyboardExtention
//
//  Created by Apple on 20/11/25.
//

import SwiftUI
import AVFoundation
import Speech

struct ContentView: View {
    
    // Track microphone permission status
    @State private var micStatus: AVAudioSession.RecordPermission = .undetermined
    
    // Track speech recognition permission status
    @State private var speechStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    @State private var showingSettingsAlert = false  // Show alert if settings can't open

    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Set up your Voice Keyboard")
                        .font(.title.bold())
                    
                    // MARK: - Checklist instructions
                    VStack(alignment: .leading, spacing: 12) {
                        checklistRow(
                            title: "Install the keyboard extension",
                            detail: "Build & run, then enable in Settings > General > Keyboard > Keyboards."
                        )
                        checklistRow(
                            title: "Enable the keyboard",
                            detail: "Settings > General > Keyboard > Keyboards > Add New Keyboard… > Your Keyboard"
                        )
                        checklistRow(
                            title: "Grant Microphone permission",
                            detail: "Needed to record your voice."
                        )
                        checklistRow(
                            title: "Grant Speech Recognition permission",
                            detail: "Needed to transcribe speech to text."
                        )
                    }
                    
                    Divider()
                    
                    // MARK: - Display current permission status
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Permissions status")
                            .font(.headline)
                        
                        statusRow(
                            name: "Microphone",
                            statusText: micStatusText,
                            ok: micStatus == .granted
                        )
                        statusRow(
                            name: "Speech",
                            statusText: speechStatusText,
                            ok: speechStatus == .authorized
                        )
                    }
                    
                    // MARK: - Buttons to request permissions
                    VStack(spacing: 12) {
                        Button(action: requestMicrophone) {
                            Label("Request Microphone Permission", systemImage: "mic")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button(action: requestSpeech) {
                            Label("Request Speech Permission", systemImage: "text.magnifyingglass")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    // MARK: - Link to open app settings
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Need to change permissions or enable the keyboard?")
                            .font(.headline)
                        
                        Button(action: openSettings) {
                            Label("Open Settings", systemImage: "gear")
                        }
                        .buttonStyle(.bordered)
                        .alert("Unable to open Settings", isPresented: $showingSettingsAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Please open Settings manually.")
                        }
                    }
                    
                } // VStack
                .padding()
            } // ScrollView
            .navigationTitle("Voice Keyboard")
            .onAppear {
                refreshStatuses()  // Check current permission status on load
            }
        } // NavigationView
    }
    
    // MARK: - Computed properties for displaying permission text
    private var micStatusText: String {
        switch micStatus {
        case .undetermined: return "Not determined"
        case .denied: return "Denied"
        case .granted: return "Granted"
        @unknown default: return "Unknown"
        }
    }
    
    private var speechStatusText: String {
        switch speechStatus {
        case .notDetermined: return "Not determined"
        case .denied: return "Denied"
        case .restricted: return "Restricted"
        case .authorized: return "Authorized"
        @unknown default: return "Unknown"
        }
    }
    
    // MARK: - UI Helper functions
    private func checklistRow(title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
    
    private func statusRow(name: String, statusText: String, ok: Bool) -> some View {
        HStack {
            Image(systemName: ok ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(ok ? .green : .orange) // Green if OK, orange if warning
            Text("\(name): \(statusText)")
        }
    }
    
    // MARK: - Permission handling functions
    private func refreshStatuses() {
        micStatus = AVAudioSession.sharedInstance().recordPermission
        speechStatus = SFSpeechRecognizer.authorizationStatus()
        // Refresh the UI when view appears
    }
    
    private func requestMicrophone() {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            DispatchQueue.main.async {
                self.micStatus = AVAudioSession.sharedInstance().recordPermission
                // Update microphone status after user decision
            }
        }
    }
    
    private func requestSpeech() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                self.speechStatus = status
                // Update speech recognition status
            }
        }
    }
    
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showingSettingsAlert = true
            // Show alert if settings cannot be opened
        }
    }
}

#Preview {
    ContentView()
}
