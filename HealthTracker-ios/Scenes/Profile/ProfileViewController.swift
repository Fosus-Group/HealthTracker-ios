//
//  ProfileViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 24.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let shapeLayer = CALayer()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController {
    
    private func setup() {
        view.layer.insertSublayer(shapeLayer, at: 0)
        setupShapeLayer()
    }
    
    private func setupShapeLayer() {
        shapeLayer.cornerRadius = Constants.shapeLayerCornerRadius
        shapeLayer.masksToBounds = true
        shapeLayer.bounds.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: Constants.shapeLayerHeight
        )
        shapeLayer.position = CGPoint(x: view.bounds.midX, y: 0)
        shapeLayer.backgroundColor = UIColor.Main.sand.cgColor
    }
    
}

private extension ProfileViewController {
    enum Constants {
        static let shapeLayerCornerRadius: CGFloat = 50
        static let shapeLayerHeight: CGFloat = 181.VAdapted
    }
}
