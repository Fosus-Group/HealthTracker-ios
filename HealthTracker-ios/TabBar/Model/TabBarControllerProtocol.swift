//
//  TabBarControllerProtocol.swift
//  HealthTracker-ios
//
//  Created by sergey on 04.11.2024.
//

import UIKit

protocol TabBarControllerProtocol: UITabBarController {
    func didTapTabBarButton(_ index: Int)
}

extension TabBarControllerProtocol {
    func didTapTabBarButton(_ index: Int) {
        selectedIndex = index
    }
}
