//
//  MainTextField.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit


final class MainTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, CSp.medium, CSp.multiply4(by: 3))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, CSp.medium, CSp.multiply4(by: 3))
    }
    
    private func setup() {
        font = Constants.Fonts.text.adapted
        textColor = .Main.green
        tintColor = .Main.green
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
