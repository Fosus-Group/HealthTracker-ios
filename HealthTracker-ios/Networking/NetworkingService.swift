//
//  NetworkingService.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

final class NetworkingService {
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    static let shared = NetworkingService()
    
    private init() { }
    
    var accessToken: String = ""
    
    @MainActor
    func makeRequest(api: API) async throws -> Data {
        
        guard let url = api.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        if api.usesAccessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let httpBody = try JSONSerialization.data(withJSONObject: api.body)
        request.httpBody = httpBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
#if DEBUG
        let jsonString = String(data: data, encoding: .utf8) ?? "No data"
        debugPrint("\(api.method) \(url): \(jsonString)")
#endif
        
        // check for refresh
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 403 {
                // TODO: POST: /api/user/refresh
                
                debugPrint("need refresh")
            }
        }
        
        return data
    }
    
    @MainActor
    func makeRequest<T: Decodable>(api: API, of type: T.Type) async throws -> T {
        
        let data = try await makeRequest(api: api)
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            guard let serverError = try? decoder.decode(ServerError.self, from: data) else {
                throw error
            }
            
            throw serverError
        }
        
    }
    
}
