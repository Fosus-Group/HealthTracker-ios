//
//  AuthService.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

protocol AuthServiceProtocol {
    func requestPhoneCall(phone: String) async -> Bool
    func verifyPhoneNumber(phone: String, code: String) async throws -> AuthVerifyDTO
}

struct AuthService: AuthServiceProtocol {
    
    private let networkService = NetworkingService.shared
    
    func requestPhoneCall(phone: String) async -> Bool {
        let api = API.userCall(phone)
        do {
            let result = try await networkService.makeRequest(api: api, of: AuthUserCallDTO.self)
            return result.success
        } catch {
            
        }
        
        return false
    }
    
    func verifyPhoneNumber(phone: String, code: String) async throws -> AuthVerifyDTO {
        let api = API.userVerify(phone, code)
        let result = try await networkService.makeRequest(api: api, of: AuthVerifyDTO.self)
        
        return result
    }
    
    
}
