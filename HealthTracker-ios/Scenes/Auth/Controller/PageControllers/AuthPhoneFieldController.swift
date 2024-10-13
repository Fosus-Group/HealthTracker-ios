//
//  AuthPhoneFieldController.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

final class AuthPhoneFieldController: AuthPageController {
    
    private let textField = MainTextField()
    
    override var pageIndex: Int { 1 }
    
    override func setup() {
        view.addSubview(textField)
        setupTextField()
        addGestures()
        super.setup()
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(CSp.multiply4(by: 31).VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.large.HAdapted)
        }
    }
    
    @objc override func nextPage() {
        // send request
        // if success -> nextPage
        super.nextPage()
    }
}

extension AuthPhoneFieldController: UITextFieldDelegate {
    
}

private extension AuthPhoneFieldController {
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: textField, action: #selector(textField.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextField() {
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = CSp.medium
        textField.delegate = self
        textField.placeholder = CSt.phoneTextfieldText
        textField.keyboardType = .phonePad
    }
}
