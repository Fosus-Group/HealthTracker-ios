//
//  ProfileViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 24.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let shapeLayer = CALayer()
    
    override var tabBarController: MainTabBarController? {
        super.tabBarController as? MainTabBarController
    }
    
    private let greetingLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = CSt.profileGreetingText
        lbl.font = .boldSystemFont(ofSize: 25)
        lbl.numberOfLines = 1
        lbl.textColor = .Main.green
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let editProfileButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.background.backgroundColor = .Main.green
        config.attributedTitle = AttributedString(CSt.editProfileButtonText, attributes: .init([
            .font : UIFont.boldSystemFont(ofSize: 12)
        ]))
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private let avatarView = AvatarView()
    
    private let carouselView = CarouselCollectionView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shapeLayer.bounds.size = CGSize(
            width: view.bounds.width,
            height: (greetingLabel.frame.maxY + CSp.medium).VAdapted
        )
        avatarView.center = .init(x: view.center.x, y: shapeLayer.frame.maxY + CSp.medium + avatarView.bounds.height / 2)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController {
    
    private func setup() {
        view.layer.insertSublayer(shapeLayer, at: 0)
        view.addSubview(greetingLabel)
        view.addSubview(avatarView)
        view.addSubview(editProfileButton)
        view.addSubview(carouselView)
        setupShapeLayer()
        makeConstraints()
    }
    
    private func setupShapeLayer() {
        shapeLayer.backgroundColor = UIColor.Main.sand.cgColor
        shapeLayer.cornerRadius = Constants.shapeLayerCornerRadius
        shapeLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        shapeLayer.masksToBounds = true
        shapeLayer.anchorPoint = .zero
        shapeLayer.position = .zero
    }
    
    private func makeConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(CSp.large.VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.large.HAdapted)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarView.snp.bottom).offset(CSp.medium)
        }
        
        carouselView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(editProfileButton.snp.bottom).offset(CSp.large)
            make.height.equalTo(319)
        }
    }
    
}

private extension ProfileViewController {
    enum Constants {
        static let shapeLayerCornerRadius: CGFloat = 50
    }
}
