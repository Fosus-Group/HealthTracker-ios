//
//  AuthManager.swift
//  HealthTracker-ios
//
//  Created by sergey on 18.11.2024.
//

import Foundation

actor AuthManager {
    private lazy var networking = NetworkingService.shared
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?

    func validToken() async throws -> Token {
        if let handle = refreshTask {
            return try await handle.value
        }

        guard let token = currentToken else {
            throw API.AuthError.missingToken
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

            guard let currentToken else { throw API.AuthError.missingToken }
            
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
