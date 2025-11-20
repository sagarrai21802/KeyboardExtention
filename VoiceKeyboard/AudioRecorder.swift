//
//  AudioRecorder.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import Foundation
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    var audioRecorder: AVAudioRecorder?  // Core audio recorder object
    @Published var isRecording = false   // Track recording state for UI updates
    private(set) var lastRecordingURL: URL?  // Store last recorded file URL
    
    // MARK: - File location for saved audio
    private var audioFileURL: URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "voice_input.m4a"  // Fixed filename
        return tempDir.appendingPathComponent(fileName)
    }
    
    // MARK: - Start recording function
    func startRecording() {
        
        // 1. Setup Audio Session
        let session = AVAudioSession.sharedInstance()
        do {
            // playAndRecord required for keyboard input
            // allowBluetoothHFP for AirPods
            // mixWithOthers so music/audio from other apps continues
            try session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetoothHFP])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
            return
        }
        
        // 2. Setup Audio Recorder settings
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),  // AAC format
            AVSampleRateKey: 12000,                     // Lower sample rate for speech
            AVNumberOfChannelsKey: 1,                   // Mono channel
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // 3. Initialize recorder and start recording
        guard let url = audioFileURL else { return }
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.record()   // Begin recording
            isRecording = true
            print("Recording started at: \(url.absoluteString)")
        } catch {
            print("Could not start recording: \(error)")
            stopRecording()  // Clean up on failure
        }
    }
    
    // MARK: - Stop recording function
    @discardableResult
    func stopRecording() -> URL? {
        audioRecorder?.stop()   // Stop recording
        isRecording = false     // Update state
        
        // Save last recording URL
        lastRecordingURL = audioFileURL
        
        // Deactivate session so other apps can resume audio
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        return lastRecordingURL
    }
}
