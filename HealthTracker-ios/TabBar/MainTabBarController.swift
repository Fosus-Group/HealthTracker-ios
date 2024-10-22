//
//  MainTabBarController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    let tabbarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


private extension MainTabBarController {
    func setup() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .Main.peach
        viewControllers = [vc1]
        view.addSubview(tabbarView)
        tabBar.removeFromSuperview()
        makeConstraints()
    }
    
    func makeConstraints() {
        tabbarView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(CSp.medium.HAdapted)
            make.height.equalTo(CSp.xlarge.VAdapted)
        }
    }
}
