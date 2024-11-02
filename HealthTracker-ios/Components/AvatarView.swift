//
//  AvatarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 30.10.2024.
//

import UIKit
import PhotosUI.PHPicker

final class AvatarView: UIView {
    
    private let placeholderImage = UIImage(systemName: "camera")
    
    
    var delegate: PHPickerViewControllerDelegate?
    
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
        imageView.bounds.size = CGSize(width: C.pencilSize, height: C.pencilSize)
        return imageView
    }()
    
    var image: UIImage? {
        didSet {
            if let image {
                avatarImageView.contentMode = .scaleAspectFill
                avatarImageView.image = image
            } else {
                avatarImageView.contentMode = .center
                let config = UIImage.SymbolConfiguration.init(pointSize: C.size / 2)
                avatarImageView.image = .init(systemName: "camera")?.withConfiguration(config)
            }
        }
    }
    
    var isEditable: Bool = false {
        didSet {
            guard oldValue != isEditable else { return }
            pencilImageView.isHidden = !isEditable
        }
    }
    
    private let rect1: CALayer = makeLayer(
        withSize: C.rect1Size,
        cornerRadius: C.rectCornerRadius,
        color: .Main.green,
        rotation: 0.5
    )
    private let rect2: CALayer = makeLayer(
        withSize: C.rect2Size,
        cornerRadius: C.rectCornerRadius,
        color: .Main.sand,
        rotation: 1
    )
    private let circle: CALayer = makeLayer(withSize: C.size, cornerRadius: C.size / 2, color: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = CGSize(width: C.rect1Size, height: C.rect1Size)
        avatarImageView.bounds.size = CGSize(width: C.size, height: C.size)
        
        if let image {
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.image = image
        } else {
            avatarImageView.contentMode = .center
            let config = UIImage.SymbolConfiguration.init(pointSize: C.size / 2)
            avatarImageView.image = .init(systemName: "camera")?.withConfiguration(config)
        }
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        avatarImageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        pencilImageView.center = CGPoint(
            x: bounds.maxX - pencilImageView.bounds.midX,
            y: bounds.maxY - pencilImageView.bounds.midY
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
        pencilImageView.isHidden = true
        
        avatarImageView.image = placeholderImage
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func didTap() {
        guard isEditable else { return }
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let photoPciker = PHPickerViewController(configuration: config)
        photoPciker.delegate = delegate
        (delegate as? UIViewController)?.present(photoPciker, animated: true, completion: nil)
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

private extension AvatarView {
    enum C {
        static let size: CGFloat = 100.HAdapted
        static let rect1Size: CGFloat = 106.HAdapted
        static let rect2Size: CGFloat = 104.HAdapted
        static let rectCornerRadius: CGFloat = 36.HAdapted
        static let pencilSize: CGFloat = 32.HAdapted
    }
}
