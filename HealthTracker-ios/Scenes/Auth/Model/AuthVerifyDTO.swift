//
//  AuthVerifyDTO.swift
//  HealthTracker-ios
//
//  Created by sergey on 05.11.2024.
//

import Foundation

struct AuthVerifyDTO: Decodable {
    let success: Bool
    let error: String?
    let accessToken: String
    let refreshToken: String
}

struct ServerError: Decodable {
    let type: String
    let title: String
    let text: String
    let status: Int
//    let detail: [Any]
}

extension ServerError: Error {}
