//
//  BuildConfiguration.swift
//  HealthTracker-ios
//
//  Created by sergey on 18.11.2024.
//

import Foundation

final class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: Environment
    
    private init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        if currentConfiguration.lowercased().hasSuffix("docker") {
            environment = .development
        } else {
            environment = .production
        }
    }
}
