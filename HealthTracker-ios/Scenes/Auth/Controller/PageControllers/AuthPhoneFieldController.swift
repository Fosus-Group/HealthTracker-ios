//
//  AuthPhoneFieldController.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

final class AuthPhoneFieldController: AuthPageController {
    
    private let textField = MainTextField()
    
    private let phoneMask = try! NSRegularExpression(pattern: "\\(\\d{3}\\) \\d{3}-\\d{2}-\\d{2}")
    
    @objc override func nextPage() {
        // send request
        // if success -> nextPage
        super.nextPage()
    }
    
    private func checkMaskMatch(string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return phoneMask.firstMatch(in: string, options: [], range: range) != nil
    }
    
    override func setup() {
        view.addSubview(textField)
        setupTextField()
        addGestures()
        super.setup()
    }
    
    override func setupMainButton() {
        super.setupMainButton()
        mainButton.isEnabled = false
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(CSp.multiply4(by: 31).VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.large.HAdapted)
        }
    }
}

extension AuthPhoneFieldController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        var newString = (text as NSString).replacingCharacters(in: range, with: string)
        if newString[newString.startIndex] == "+" {
            // remove code (+X)
            if newString.count > 2 { newString.removeFirst(2) }
        }
        let formatted = format(with: "(XXX) XXX-XX-XX", phone: newString)
        textField.text = formatted
        mainButton.isEnabled = checkMaskMatch(string: formatted)
        return false
    }
}

private extension AuthPhoneFieldController {
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: textField, action: #selector(textField.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.placeholder = CSt.phoneTextfieldText
        textField.keyboardType = .numberPad
    }
}
