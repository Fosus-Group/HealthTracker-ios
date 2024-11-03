//
//  CustomTabBar.swift
//  HealthTracker-ios
//
//  Created by sergey on 03.11.2024.
//

import UIKit

final class CustomTabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let tabbarView = TabBarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tabbarView)
        
//        guard let scendeDelegate = (self.window?.windowScene?.delegate as? SceneDelegate) else { return }
//        if scendeDelegate.deviceHasNotch {
            tabbarView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
//        } else {
//            tabbarView.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
//        }
    }
    
    override var selectedItem: UITabBarItem? {
        didSet {
            guard let selectedItem else { return }
            guard let index = items?.firstIndex(where: { $0 == selectedItem }) else { return }
            tabbarView.selectedIndex = index
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
