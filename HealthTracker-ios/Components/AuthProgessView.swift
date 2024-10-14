//
//  AuthProgessView.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

final class AuthProgessView: UIView {
    
    let total: Int
    private(set) var progress: Int = 0
    
    private let segmentLayer = CALayer()
    private var segmentWidth: CGFloat = 0
    
    init(total: Int) {
        self.total = total
        super.init(frame: .zero)
        setup()
    }
    
    func setProgress(_ value: Int) {
        self.progress = value
        animate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height
        self.segmentWidth = width / CGFloat(total)
        layer.cornerRadius = height / 2
        segmentLayer.position = calculateCenter(index: progress, width: segmentWidth)
        segmentLayer.bounds.size = .init(width: segmentWidth, height: height)
        segmentLayer.cornerRadius = height / 2
    }
    
    private func animate() {
        let initialValue = segmentLayer.position.x
        let finalValue = calculateCenter(index: progress, width: segmentWidth).x
        CATransaction.setDisableActions(true)
        segmentLayer.position.x = finalValue
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = initialValue
        animation.toValue = finalValue
        animation.duration = 0.25
        segmentLayer.add(animation, forKey: "Reposition")
        CATransaction.setDisableActions(false)
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        layer.addSublayer(segmentLayer)
        backgroundColor = .Main.green
        segmentLayer.backgroundColor = UIColor.Main.light.cgColor
        segmentLayer.borderColor = UIColor.Main.green.cgColor
        segmentLayer.borderWidth = 1
    }
    
    private func calculateCenter(index: Int, width: CGFloat) -> CGPoint {
        let relative = (CGFloat(index + 1) / CGFloat(total)) * bounds.width
        return .init(x: relative - (width / 2), y: bounds.midY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
