//
//  ServerError.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import Foundation

struct ServerError: Decodable {
    let type: String
    let title: String
    let text: String
    let status: Int
//    let detail: [Any]
}

extension ServerError: Error {}
