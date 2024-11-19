//
//  MainTabBarController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let tabbarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tabBarSize = tabBar.bounds.size
        var offset: CGFloat = 0
        if view.safeAreaInsets.bottom > 0 {
            offset = CSp.large.HAdapted
        }
        tabbarView.bounds.size.width = tabBarSize.width - offset
        tabbarView.bounds.size.height = tabBarSize.height - view.safeAreaInsets.bottom
        
        tabbarView.center = CGPoint(x: tabBar.center.x, y: tabbarView.bounds.height / 2)
    }
    
}


private extension MainTabBarController {
    func setup() {
        viewControllers = TabBarButton.allCases.map { generateViewController($0) }
        
        Task {
            let service = ProfileService(networking: NetworkingService.shared)
            let profile: ProfileModel
            do {
                profile = try await service.loadProfile()
            } catch {
                self.showAlert(error: error)
                profile = ProfileModel.getFromDisk()
            }
            let vc = ProfileViewController(profileService: service, profileModel: profile)
            let nav = UINavigationController(rootViewController: vc)
            viewControllers?[0] = nav
            tabBar.bringSubviewToFront(tabbarView)
        }
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.addSubview(tabbarView)
        tabbarView.tabBarController = self
    }
    
    private func generateViewController(_ type: TabBarButton) -> UIViewController {
        let defaultVC = UIViewController()
        defaultVC.view.backgroundColor = .black
        return defaultVC
    }
}

extension MainTabBarController: TabBarControllerProtocol {}
