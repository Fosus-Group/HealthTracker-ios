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
        customRect(forBounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        customRect(forBounds: bounds)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += CSp.small
        return rect
    }
    
    private func customRect(forBounds bounds: CGRect) -> CGRect {
        let leftViewEnd = leftView?.frame.maxX ?? 0
        let dx = leftViewEnd + CSp.min
        var rect = CGRectInset(bounds, dx, CSp.multiply4(by: 3))
        rect.size.width += dx // remove padding from right side
        return rect
    }
    
    private func setup() {
        font = CFs.text.adapted
        textColor = .Main.green
        tintColor = .Main.green
        backgroundColor = UIColor.white
        layer.cornerRadius = CSp.medium
        
        let leftView = UILabel()
        leftView.text = "+7"
        leftView.textColor = .Main.green
        leftView.font = CFs.text.adapted
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
