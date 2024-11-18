//
//  UIApplication.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.11.2024.
//

import UIKit.UIApplication

extension UIApplication {
    var window: UIWindow? {
        connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
    }
}
