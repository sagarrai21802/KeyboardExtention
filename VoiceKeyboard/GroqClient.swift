
//
//  GroqClient.swift
//  VoiceKeyboard
//
//  Created by Apple on 20/11/25.
//

import Foundation

struct GroqResponse: Codable {
    let text: String
}

struct GroqErrorResponse: Codable {
    let error: GroqErrorDetail
}

struct GroqErrorDetail: Codable {
    let message: String
}

class GroqClient {
    
    func transcribe(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        
        // 1. Endpoint
        let url = URL(string: "https://api.groq.com/openai/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 2. Boundaries for Multipart
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("Bearer \(Secrets.groqApiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 3. Build Body
        var body = Data()
        
        // Model Parameter
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n")
        body.append("whisper-large-v3\r\n")
        
        // Response Format Parameter
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n")
        body.append("json\r\n")
        
        // File Parameter
        do {
            let audioData = try Data(contentsOf: audioURL)
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"voice.m4a\"\r\n")
            body.append("Content-Type: audio/m4a\r\n\r\n")
            body.append(audioData)
            body.append("\r\n")
        } catch {
            completion(.failure(error))
            return
        }
        
        // End Boundary
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        // 4. Send Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                // Check for Success (200 OK)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    let result = try JSONDecoder().decode(GroqResponse.self, from: data)
                    completion(.success(result.text))
                } else {
                    // Try to decode error message
                    if let errorResult = try? JSONDecoder().decode(GroqErrorResponse.self, from: data) {
                        let apiError = NSError(domain: "GroqAPI", code: 400, userInfo: [NSLocalizedDescriptionKey: errorResult.error.message])
                        completion(.failure(apiError))
                    } else {
                        completion(.failure(NSError(domain: "GroqAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown API Error"])))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Helper to append strings to Data
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
