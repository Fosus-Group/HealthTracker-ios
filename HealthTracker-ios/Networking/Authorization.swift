//
//    Authorization.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import Foundation

struct Authorization {
    let accessToken: String
    let refreshToken: String
}

extension Authorization: Decodable {}

extension Authorization: DTOConvertible {
    static func fromDTO(_ dto: AuthVerifyDTO) -> Self {
        Self(accessToken: dto.accessToken, refreshToken: dto.refreshToken)
    }
}
