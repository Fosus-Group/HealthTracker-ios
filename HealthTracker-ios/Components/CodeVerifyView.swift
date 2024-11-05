//
//  CodeVerifyView.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

protocol CodeVerifyViewDelegate: AnyObject {
    func didFillCode(_ code: String)
}

final class CodeVerifyView: UIView {
    
    private let textField = UITextField()
    private let stackView = UIStackView()
    
    let count: Int
    
    weak var delegate: CodeVerifyViewDelegate?
    
    private var labels: [UILabel] {
        stackView.arrangedSubviews as! [UILabel]
    }
    
    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        setup()
    }
    
    func clearCode() {
        textField.text = ""
        labels.forEach { $0.text = "" }
    }
    
    @objc private func textChange(textField: UITextField) {
        guard var text = textField.text, !text.isEmpty else {
            clearCode()
            return
        }
        
        text = String(text.prefix(self.count))
        textField.text = text
        
        var textIterator = text.makeIterator()
        
        for label in labels {
            if let ch = textIterator.next() {
                label.text = String(ch)
            } else {
                label.text = ""
            }
        }
        
        if text.count == self.count {
            delegate?.didFillCode(text)
        }
    }
    
    @objc private func openKeyboard() {
        textField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CodeVerifyView {
    private func setup() {
        addSubview(stackView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openKeyboard))
        addGestureRecognizer(tapGesture)
        setupStackView()
        setupTextfield()
        makeConstraints()
    }
    
    private func setupStackView() {
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = CSp.medium
        stackView.alignment = .center
        addSubview(textField)
        for _ in 0..<count {
            stackView.addArrangedSubview(makeCodeLabel())
        }
    }
    
    private func setupTextfield() {
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textChange(textField:)), for: .editingChanged)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeCodeLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .white
        label.font = Constants.Fonts.button
        label.textColor = .Main.green
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.snp.makeConstraints { make in
            make.size.equalTo(Constants.authCodeHeight)
        }
        return label
    }
}
