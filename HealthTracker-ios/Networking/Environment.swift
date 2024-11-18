//
//  Environment.swift
//  HealthTracker-ios
//
//  Created by sergey on 18.11.2024.
//

import Foundation

enum Environment: String {
    case development
    case production
    
    var host: String {
        switch self {
        case .development:
            return "localhost"
        case .production:
            return "d5d344h7p2lb2srofdnv.apigw.yandexcloud.net"
        }
    }
    
    var port: Int? {
        switch self {
        case .development:
            return 80
        case .production:
            return nil
        }
    }
    
    var scheme: String {
        switch self {
        case .development:
            return "http"
        case .production:
            return "https"
        }
    }
}
