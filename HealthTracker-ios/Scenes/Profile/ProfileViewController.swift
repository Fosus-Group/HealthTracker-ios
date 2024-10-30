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
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController {
    
    private func setup() {
        view.layer.insertSublayer(shapeLayer, at: 0)
        view.addSubview(greetingLabel)
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
    }
    
}

private extension ProfileViewController {
    enum Constants {
        static let shapeLayerCornerRadius: CGFloat = 50
    }
}
