//
//  AuthManager.swift
//  HealthTracker-ios
//
//  Created by sergey on 18.11.2024.
//

import Foundation

actor AuthManager {
    enum TokenError: Error {
        case invalidConfiguration
        case missingToken
        case invalidToken
    }
    
    private weak var networking: NetworkingService?
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?
    
    init(networking: NetworkingService) {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken"),
           let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        {
            let authorization = Authorization(accessToken: accessToken, refreshToken: refreshToken)
            let token = Token(authorization: authorization, expireDate: .now + 43200 * 60)
            self.currentToken = token
        }
        self.networking = networking
    }

    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }

        guard let token = currentToken else {
            throw TokenError.missingToken
        }

        // TODO: Check if token is valid (Date)
        
        if token.isValid {
            return token
        }
        
        return try await refreshToken()
    }

    func refreshToken() async throws -> Token {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let task = Task { () throws -> Token in
            defer { refreshTask = nil }

            guard let currentToken else { throw TokenError.missingToken }
            guard let networking else { throw TokenError.invalidConfiguration }
            
            let newToken = try await networking.refreshToken(currentToken.refreshToken)
            
            self.currentToken = newToken

            return newToken
        }

        self.refreshTask = task

        return try await task.value
    }
    
    func saveToken(_ token: Token) {
        currentToken = token
    }
}
