//
//  API.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

enum API: RawRepresentable {
    
    typealias RawValue = String
    
    case userCall(_ phone: String)
    case userVerify(_ phone: String, _ code: String)
    
    init?(rawValue: String) { nil }
    
    var rawValue: String {
        switch self {
        case .userCall:
            return "user/call"
        case .userVerify:
            return "user/verify"
        }
    }
    
    var path: String {
        return "/api/\(rawValue)"
    }
    
    var method: HttpMethod {
        switch self {
        case .userCall, .userVerify:
            return .post
        default:
            return .get
        }
    }
    
    var usesAccessToken: Bool {
        switch self {
        case .userCall, .userVerify:
            return false
        default:
            return true
        }
    }
    
    
    var body: [String:Any] {
        switch self {
        case .userCall(let phone):
            return ["phone_number": phone]
        case .userVerify(let phone, let code):
            return ["phone_number": phone, "code": code]
        default:
            return [:]
        }
    }
    
    var url: URL? {
        let environment = BuildConfiguration.shared.environment
        var components = URLComponents()
        components.scheme = environment.scheme
        components.host = environment.host
        components.port = environment.port
        components.path = path
        
        return components.url
    }
}

extension API {
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
}
