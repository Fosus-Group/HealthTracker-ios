//
//  ProfileEditorTextField.swift
//  HealthTracker-ios
//
//  Created by sergey on 02.11.2024.
//

import UIKit

final class ProfileEditorTextField: UITextField {
    
    private let bottomLine = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.bounds.size = CGSize(width: bounds.width, height: 1)
        bottomLine.position = .init(x: bounds.midX, y: bounds.maxY)
    }
    
    private func setup() {
        font = .boldSystemFont(ofSize: 13)
        borderStyle = .none
        setupBottomLine()
    }
    
    private func setupBottomLine() {
        layer.insertSublayer(bottomLine, at: 0)
        bottomLine.backgroundColor = .init(gray: 0, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




