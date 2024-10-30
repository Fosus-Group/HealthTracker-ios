//
//  AvatarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 30.10.2024.
//

import UIKit

final class AvatarView: UIView {
    
    private let placeholderImage = UIImage(systemName: "camera")
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .Main.green
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let pencilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .Icon.pencil
        imageView.bounds.size = CGSize(width: 32, height: 32)
        return imageView
    }()
    
    var image: UIImage? {
        didSet { avatarImageView.image = image ?? placeholderImage }
    }
    
    private lazy var rect1: CALayer = makeRectangleShape(size: 106, color: .Main.green, 0.5)
    private lazy var rect2: CALayer = makeRectangleShape(size: 104, color: .Main.sand, 1)
    
    private lazy var circle: CALayer = {
        let circle = CALayer()
        circle.bounds.size = .init(width: 100, height: 100)
        circle.backgroundColor = UIColor.white.cgColor
        circle.cornerRadius = 50
        circle.masksToBounds = true
        return circle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: 106, height: 106)
        
        if image == nil {
            avatarImageView.bounds.size = CGSize(width: 100, height: 100)
            avatarImageView.contentMode = .center
            let config = UIImage.SymbolConfiguration.init(pointSize: 50)
            avatarImageView.image = .init(systemName: "camera")?.withConfiguration(config)
        } else {
            avatarImageView.bounds.size = CGSize(width: 100, height: 100)
            avatarImageView.contentMode = .scaleAspectFit
        }
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let pencilSize = CGSize(width: 32, height: 32)
        pencilImageView.center = CGPoint(
            x: bounds.maxX - pencilSize.width / 2,
            y: bounds.maxY - pencilSize.height / 2
        )
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        rect1.position = CGPoint(x: layer.bounds.midX, y: layer.bounds.midY)
        rect2.position = rect1.position
        circle.position = rect1.position
    }
    
    func setup() {
        layer.insertSublayer(rect1, at: 0)
        layer.insertSublayer(rect2, above: rect1)
        
        addSubview(avatarImageView)
        addSubview(pencilImageView)
        
        avatarImageView.image = placeholderImage
    }
    
    private func makeRectangleShape(size: CGFloat, color: UIColor, _ rotation: CGFloat) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds.size = CGSize(width: size, height: size)
        shapeLayer.cornerRadius = 36
        shapeLayer.backgroundColor = color.cgColor
        shapeLayer.setAffineTransform(.init(rotationAngle: rotation))
        return shapeLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
