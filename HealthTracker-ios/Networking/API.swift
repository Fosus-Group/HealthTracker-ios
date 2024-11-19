//
//  API.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import Foundation

enum API: RawRepresentable {
    
    typealias RawValue = String
    
    // MARK: User
    case userCall(_ phone: String)
    case userVerify(_ phone: String, _ code: String)
    case userMe
    case userUpdate(_ username: String, _ height: Double)
    case userUpload(_ image: Data)
    
    // MARK: Auth
    case refresh(_ refresh: String)
    
    init?(rawValue: String) { nil }
    
    var rawValue: String {
        switch self {
        case .userCall:
            return "user/call"
        case .userVerify:
            return "user/verify"
        case .userMe:
            return "user/me"
        case .userUpdate:
            return "user/update"
        case .userUpload:
            return "user/upload"
        case .refresh:
            return "user/refresh"
        }
    }
    
    var path: String {
        return "/api/\(rawValue)"
    }
    
    var method: HttpMethod {
        switch self {
        case .userCall, .userVerify, .refresh:
            return .post
        case .userUpdate:
            return .put
        default:
            return .get
        }
    }
    
    var usesAccessToken: Bool {
        switch self {
        case .userCall, .userVerify, .userUpload:
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
        case .userUpdate(let username, let height):
            return ["username": username, "height": height]
        case .userUpload(let image):
            return ["file": image]
        default:
            return [:]
        }
    }
    
    var bodyData: Data? {
        let data = try? JSONSerialization.data(withJSONObject: body)

        return data
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
        case put = "PUT"
        case delete = "DELETE"
    }
}
