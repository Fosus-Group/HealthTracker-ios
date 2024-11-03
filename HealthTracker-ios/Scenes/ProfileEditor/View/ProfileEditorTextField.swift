//
//  ProfileEditorTextField.swift
//  HealthTracker-ios
//
//  Created by sergey on 02.11.2024.
//

import UIKit

final class ProfileEditorTextField: UITextField {
    
    private let bottomLine = CALayer()
    
    let fieldType: ProfileEditorField
    
    init(fieldType: ProfileEditorField) {
        self.fieldType = fieldType
        super.init(frame: .zero)
        setup()
    }
    
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width, height: size.height + 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.bounds.size = CGSize(width: bounds.width, height: 1)
        bottomLine.position = .init(x: bounds.midX, y: bounds.maxY)
    }
    
    private func setup() {
        font = .boldSystemFont(ofSize: 13)
        borderStyle = .none
        
        placeholder = fieldType.placeholder
        keyboardType = fieldType.keyboardType
        autocapitalizationType = fieldType.capitalizationType
        autocorrectionType = .no
        returnKeyType = .done
        tag = fieldType.rawValue
        
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

