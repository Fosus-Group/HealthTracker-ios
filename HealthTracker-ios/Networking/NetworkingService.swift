//
//  NetworkingService.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

protocol NetworkingServiceProtocol: AnyObject {
    func makeRequest(apiRequest: API.Request, allowRetry: Bool) async throws -> Data
    func makeRequest<T: Decodable>(apiRequest: API.Request, ofType type: T.Type) async throws -> T
    func makeRequest(api: API) async throws -> Data
    func makeRequest<T: Decodable>(api: API, of type: T.Type) async throws -> T
    func refreshToken(_ refresh: String) async throws -> Token
    func saveToken(_ token: Token) async
}

final class NetworkingService: NetworkingServiceProtocol {
    
    static let shared = NetworkingService()
    
    private let logger = Logger()
    
    private lazy var authManager: AuthManager = .init(networking: self)
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private init() {}
    
    // MARK: - Methdods
    @MainActor
    func makeRequest(apiRequest: API.Request, allowRetry: Bool) async throws -> Data {
        
        var request = URLRequest(url: apiRequest.url)
        
        request.httpMethod = apiRequest.method.rawValue
        
        if apiRequest.usesAccessToken {
            if apiRequest.url.lastPathComponent == "refresh" {
                guard let token = await authManager.currentToken else { throw AuthManager.TokenError.missingToken }
                request.setValue("Bearer \(token.refreshToken)", forHTTPHeaderField: "Authorization")
            } else {
                let token = try await authManager.validToken()
                request.setValue("Bearer \(token.accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
        
        if let formData = apiRequest.formData {
            let (body, contentType) = formData.build()
            request.httpBody = body
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        } else {
            if !apiRequest.body.isEmpty {
                let httpBody = try JSONSerialization.data(withJSONObject: apiRequest.body)
                request.httpBody = httpBody
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
#if DEBUG
        logger.log(request: request, response: response, data: data)
#endif
        
        // check for refresh
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 403 {
                if allowRetry {
                    _ = try await authManager.refreshToken()
                    return try await makeRequest(apiRequest: apiRequest, allowRetry: false)
                }
                
                throw AuthManager.TokenError.invalidToken
            }
        }
        
        return data
    }
    
    @MainActor
    func makeRequest<T: Decodable>(apiRequest: API.Request, ofType type: T.Type) async throws -> T {
        let data = try await makeRequest(apiRequest: apiRequest, allowRetry: true)
        
        return try decode(data)
    }
    
    
    @MainActor
    func makeRequest(api: API) async throws -> Data {
        let apiRequest = try API.Request(api: api)
        
        return try await makeRequest(apiRequest: apiRequest, allowRetry: true)
    }
    
    @MainActor
    func makeRequest<T: Decodable>(api: API, of type: T.Type) async throws -> T {
        let data = try await makeRequest(api: api)
        
        return try decode(data)
    }
    
    func refreshToken(_ refresh: String) async throws -> Token {
        let api = API.refresh(refresh)
        let result = try await makeRequest(api: api, of: Token.DTO.self)
        
        return Token.fromDTO(result)
    }
    
    func saveToken(_ token: Token) async {
        await authManager.saveToken(token)
    }
    
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
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


extension API {
    struct Request {
        let url: URL
        let method: HttpMethod
        let body: [String: Any]
        let formData: MultipartFormData?
        let usesAccessToken: Bool
        
        init(
            url: URL,
            method: HttpMethod,
            body: [String : Any],
            formData: MultipartFormData?,
            usesAccessToken: Bool
        ) {
            self.url = url
            self.method = method
            self.body = body
            self.formData = formData
            self.usesAccessToken = usesAccessToken
        }
        
        init(api: API) throws {
            guard let url = api.url else {
                throw URLError(.badURL)
            }
            self.url = url
            self.usesAccessToken = api.usesAccessToken
            self.method = api.method
            self.body = api.body
            self.formData = api.muliPart
        }
        
        static func get(url: URL, usesAccessToken: Bool = false) -> Request {
            Request(
                url: url,
                method: .get,
                body: [:],
                formData: nil,
                usesAccessToken: usesAccessToken
            )
        }
    }
}


struct Logger {
    func log(request: URLRequest, response: URLResponse, data: Data) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        let authorizationHeader = request.value(forHTTPHeaderField: "Authorization")
        
        let jsonString = String(data: data, encoding: .utf8) ?? "No data"
        let httpMethod = request.httpMethod ?? "No method"
        let url = request.url?.absoluteString ?? "No url"
        
        let output: String = {
            if let authorizationHeader {
                return "\(httpMethod) \(url) \(statusCode) \(authorizationHeader) \(jsonString)"
            } else {
                return "\(httpMethod) \(url) \(statusCode) \(jsonString)"
            }
        }()
        
        print(output)
    }
}
