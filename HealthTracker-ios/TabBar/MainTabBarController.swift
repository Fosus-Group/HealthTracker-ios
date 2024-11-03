//
//  MainTabBarController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
//    let tabbarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}


private extension MainTabBarController {
    func setup() {
//        tabBar.removeFromSuperview()
//        tabBar.isHidden = true
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        viewControllers = TabBarButton.allCases.map(\.viewcontroller)
//        view.addSubview(tabbarView)
//        tabbarView.tabBarController = self
        makeConstraints()
    }
    
    func makeConstraints() {
//        tabbarView.snp.makeConstraints { make in
//            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(CSp.medium)
//            make.height.equalTo(CSp.xlarge.VAdapted)
//        }
    }
}

extension MainTabBarController: TabBarControllerProtocol {}
