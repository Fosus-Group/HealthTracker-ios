//
//  MainTextField.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit


final class MainTextField: UITextField {
    
    private let codeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    var code: String {
        "+7"
    }
    
    var phoneNumber: String? {
        guard let text else { return nil }
        let digits = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return "\(code)\(digits)"
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
        
        codeLabel.text = code
        codeLabel.textColor = .Main.green
        codeLabel.font = CFs.text.adapted
        self.leftViewMode = .always
        self.leftView = codeLabel
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
