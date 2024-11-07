//
//  ProfileViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 24.10.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let shapeLayer = CALayer()
    
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
    
    private var profileModel: ProfileModel{
        get {
            // TODO: Network request
            let saved = ProfileModel.getFromDisk()
            return saved
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        
        greetingLabel.sizeToFit()
        greetingLabel.center = .init(
            x: view.center.x,
            y: safeAreaFrame.minY + greetingLabel.bounds.height / 2 + CSp.large
        )
        
        avatarView.center = .init(
            x: view.center.x,
            y: greetingLabel.frame.maxY + avatarView.bounds.height / 2 + CSp.large
        )
        
        editProfileButton.sizeToFit()
        editProfileButton.center = .init(
            x: view.center.x,
            y: avatarView.frame.maxY + editProfileButton.bounds.height / 2 + CSp.medium
        )
        
        shapeLayer.bounds.size = CGSize(
            width: view.bounds.width,
            height: greetingLabel.frame.maxY + CSp.medium
        )
        
        if let tabbarView = tabBarController?.tabBar {
            carouselView.bounds.size = CGSize(
                width: view.bounds.width,
                height: tabbarView.frame.minY - editProfileButton.frame.maxY
            )
        }
        
        carouselView.center = CGPoint(
            x: view.center.x,
            y: editProfileButton.frame.maxY + carouselView.bounds.height / 2
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupAvatarView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func editProfileButtonTapped() {
        let vc = ProfileEditorViewController(profileModel: profileModel)
        navigationController?.pushViewController(vc, animated: true)
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
        setupAvatarView()
        setupEditProfileButton()
        setupShapeLayer()
    }
    
    private func setupAvatarView() {
        avatarView.image = profileModel.profilePicture
    }
    
    private func setupEditProfileButton() {
        editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
    }
    
    private func setupShapeLayer() {
        shapeLayer.backgroundColor = UIColor.Main.sand.cgColor
        shapeLayer.cornerRadius = Constants.shapeLayerCornerRadius
        shapeLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        shapeLayer.masksToBounds = true
        shapeLayer.anchorPoint = .zero
        shapeLayer.position = .zero
    }
    
}

private extension ProfileViewController {
    enum Constants {
        static let shapeLayerCornerRadius: CGFloat = 50
    }
}
