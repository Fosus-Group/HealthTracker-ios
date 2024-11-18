//
//  NetworkingService.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

protocol NetworkingServiceProtocol: AnyObject {
    func makeRequest(api: API, allowRetry: Bool) async throws -> Data
    func makeRequest<T: Decodable>(api: API, of type: T.Type) async throws -> T
    func refreshToken(_ refresh: String) async throws -> Token
    func saveToken(_ token: Token) async
}

final class NetworkingService: NetworkingServiceProtocol {
    
    static let shared = NetworkingService()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let authManager = AuthManager()
    
    private init() {}
    
    @MainActor
    func makeRequest(api: API, allowRetry: Bool = true) async throws -> Data {
        
        guard let url = api.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        
        if api.usesAccessToken {
            let token = try await authManager.validToken()
            request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
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
                if allowRetry {
                    _ = try await authManager.refreshToken()
                    return try await makeRequest(api: api, allowRetry: false)
                }
                
                throw API.AuthError.invalidToken
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
    
    func refreshToken(_ refresh: String) async throws -> Token {
        let api = API.refresh(refresh)
        let result = try await makeRequest(api: api, of: Token.DTO.self)
        
        return Token.fromDTO(result)
    }
    
    func saveToken(_ token: Token) async {
        await authManager.saveToken(token)
    }
    
}
