//
//  MainTabBarController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        
        setup()
        
    }
}


private extension MainTabBarController {
    func setup() {
        viewControllers = [AuthController()]
    }
}
