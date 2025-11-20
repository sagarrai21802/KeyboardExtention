//
//  GroqClient.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import Foundation

// MARK: - Model for decoding API response
struct GroqResponse: Codable {
    let text: String   // Transcribed text from audio
}

class GroqClient {
    
    // MARK: - Transcribe audio file using Groq API
    func transcribe(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        // 1. Prepare request
        let url = URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 2. Setup headers for multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("Bearer \(Secrets.groqApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 3. Build multipart body
        var body = Data()
        let modelName = "whisper-large-v3"  // Groq's fast transcription model
        
        // Add model parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(modelName)\r\n".data(using: .utf8)!)
        
        // Add audio file
        do {
            let audioData = try Data(contentsOf: audioURL)
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"voice.m4a\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)
        } catch {
            completion(.failure(error))  // Fail if audio file can't be read
            return
        }
        
        // Close the multipart body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // 4. Send the request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Handle network errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure data is received
            guard let data = data else { return }
            
            do {
                // Debugging: Print raw JSON if needed
                // print(String(data: data, encoding: .utf8)!)
                
                // Decode JSON response
                let result = try JSONDecoder().decode(GroqResponse.self, from: data)
                completion(.success(result.text))  // Return transcribed text
            } catch {
                completion(.failure(error))  // Handle decoding errors
            }
            
        }.resume()
    }
}
