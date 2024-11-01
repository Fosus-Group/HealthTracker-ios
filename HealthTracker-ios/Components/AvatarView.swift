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
    
    private let rect1: CALayer = makeLayer(withSize: 106, cornerRadius: 36, color: .Main.green, rotation: 0.5)
    private let rect2: CALayer = makeLayer(withSize: 104, cornerRadius: 36, color: .Main.sand, rotation: 1)
    private let circle: CALayer = makeLayer(withSize: 100, cornerRadius: 50, color: .white)
    
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
    
    private func setup() {
        layer.insertSublayer(rect1, at: 0)
        layer.insertSublayer(rect2, above: rect1)
        
        addSubview(avatarImageView)
        addSubview(pencilImageView)
        
        avatarImageView.image = placeholderImage
    }
    
    private static func makeLayer(withSize size: CGFloat, cornerRadius: CGFloat, color: UIColor, rotation: CGFloat? = nil) -> CALayer {
        let layer = CALayer()
        layer.bounds.size = CGSize(width: size, height: size)
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = color.cgColor
        if let rotation {
            layer.setAffineTransform(.init(rotationAngle: rotation))
        }
        
        return layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
