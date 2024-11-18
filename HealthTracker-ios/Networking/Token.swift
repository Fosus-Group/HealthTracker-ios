//
//  Token.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import Foundation

struct Token {
    let authorization: Authorization
    let expireDate: Date
    
    var refreshToken: String {
        authorization.refreshToken
    }
    
    var accessToken: String {
        authorization.accessToken
    }
    
    var isValid: Bool {
        Date() < expireDate
    }
}

extension Token: DTOConvertible {
    typealias DTO = Authorization
    
    static func fromDTO(_ dto: Authorization) -> Self {
        Self(
            authorization: dto,
            expireDate: .now
        )
    }
}
