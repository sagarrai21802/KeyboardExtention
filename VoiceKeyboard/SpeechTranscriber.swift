//
//  SpeechTranscriber.swift
//
//  Provides offline/online Apple Speech transcription for a local audio file URL.
//  Usage from KeyboardView:
//  SpeechTranscriber().transcribeFile(at: audioURL) { result in
//      switch result {
//      case .success(let transcription):
//          print("Transcription: \(transcription)")
//      case .failure(let error):
//          print("Error: \(error.localizedDescription)")
//      }
//  }
//

import Foundation
import Speech

final class SpeechTranscriber {
    
    private let recognizer = SFSpeechRecognizer()  // Apple Speech recognizer
    
    // MARK: - Transcribe local audio file
    func transcribeFile(at url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Request speech recognition authorization
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else {
                completion(.failure(
                    NSError(
                        domain: "SpeechTranscriber",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Speech recognition not authorized"]
                    )
                ))
                return
            }
            
            // Prepare the recognition request
            let request = SFSpeechURLRecognitionRequest(url: url)
            request.shouldReportPartialResults = false  // Only final result
            request.requiresOnDeviceRecognition = false // Set true if you want strictly on-device
            
            // Start recognition task
            self.recognizer?.recognitionTask(with: request) { result, error in
                if let error = error {
                    completion(.failure(error))  // Handle errors
                    return
                }
                
                if let result = result, result.isFinal {
                    // Send back the final transcribed text
                    completion(.success(result.bestTranscription.formattedString))
                }
            }
        }
    }
}
