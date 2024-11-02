//
//  ProfileEditorViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit
import PhotosUI.PHPicker

final class ProfileEditorViewController: UIViewController {
    
    private(set) var profileModel: ProfileModel
    
    private let avatarView = AvatarView()
    
    private let fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = CSp.medium
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let saveButton = MainButton(title: CSt.saveText)
    
    private let usernameTextField = ProfileEditorTextField(editorField: .username)
    private let firstNameTextField = ProfileEditorTextField(editorField: .firstName)
    private let weightTextField = ProfileEditorTextField(editorField: .weight)
    private let heightTextField = ProfileEditorTextField(editorField: .height)
    
    var textFields: [ProfileEditorTextField] {
        [usernameTextField, firstNameTextField, weightTextField, heightTextField]
    }
    
    init(profileModel: ProfileModel) {
        self.profileModel = profileModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (tabBarController as? MainTabBarController)?.tabbarView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (tabBarController as? MainTabBarController)?.tabbarView.isHidden = false
    }
    
    @objc private func saveProfile() {
        guard let username = usernameTextField.text,
              let firstName = firstNameTextField.text,
              let weightString = weightTextField.text,
              let heightString = heightTextField.text,
              let weight = Double(weightString),
              let height = Double(heightString)
        else { return }
              
        let profileModel = ProfileModel(
            username: username,
            firstName: firstName,
            weight: weight,
            height: height,
            profilePicture: avatarView.image
        )
        
        let result = UserDefaults.standard.saveProfileModel(profileModel)
        switch result {
        case .success(_):
            navigationController?.popViewController(animated: true)
            return
        case .failure(let failure):
            let alert = UIAlertController(title: "Error", message: failure.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default) { [self] action in
                navigationController?.popViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    @objc private func dismissKeyboard() {
        for textField in textFields {
            textField.endEditing(false)
        }
    }
    
    var canSave: Bool {
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty else {
                return false
            }
        }
        
        return true
    }
    
    private func layoutViews() {
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        
        avatarView.center = CGPoint(
            x: view.center.x,
            y: safeAreaFrame.minY + avatarView.bounds.midY
        )
        
        saveButton.bounds.size = .init(width: view.bounds.width - CSp.large, height: 64)
        saveButton.center = CGPoint(
            x: view.center.x,
            y: safeAreaFrame.maxY - saveButton.bounds.midY - CSp.medium
        )
        
//        let fieldStackViewSize = fieldStackView.systemLayoutSizeFitting(
//            .init(
//                width: view.bounds.width,
//                height: saveButton.frame.minY - avatarView.frame.maxY
//            ),
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .defaultLow
//        )
//        
//        fieldStackView.bounds.size = .init(
//            width: view.bounds.width - CSp.large,
//            height: fieldStackViewSize.height
//        )
//        fieldStackView.center = CGPoint(
//            x: view.center.x,
//            y: avatarView.frame.maxY + fieldStackViewSize.height / 2 + CSp.xlarge
//        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension ProfileEditorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = canSave
        
        guard let editorTextField = textField as? ProfileEditorTextField else { return }
        guard let text = textField.text else { return  }
        
        switch editorTextField.editorField {
        case .weight, .height:
            textField.text = text.replacingOccurrences(of: ",", with: ".")
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // TODO: Regex
        
        guard let editorTextField = textField as? ProfileEditorTextField else { return false }
        guard let text = textField.text else { return false }
        var newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        switch editorTextField.editorField {
        case .username:
            if string.contains(where: { ch in
                !ch.isLetter && !ch.isHexDigit
            }) {
                return false
            }
        case .firstName:
            if string.contains(where: { ch in
                !ch.isLetter && !ch.isWhitespace
            }) {
                return false
            }
        case .weight, .height:
            newString = newString.replacingOccurrences(of: ",", with: ".")
            if Double(newString) == nil {
                return newString.isEmpty
            } else {
                return true
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return false
    }
}

extension ProfileEditorViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let firstResult = results.first else { return }
        
        if firstResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            firstResult.itemProvider.loadObject(ofClass: UIImage.self) { [avatarView] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        avatarView.image = image
                    }
                }
            }
        }
    }
}

// MARK: UI Setup
extension ProfileEditorViewController {
    
    private func setup() {
        view.addSubview(avatarView)
        view.addSubview(saveButton)
        view.backgroundColor = .systemBackground
        setupGesture()
        view.addSubview(fieldStackView)
        setupScrollView()
        setupAvtarView()
        setupSaveButton()
        
        
        fieldStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(CSp.medium)
            make.top.equalTo(avatarView.snp.bottom).offset(CSp.xlarge)
        }
    }
    
    private func setupAvtarView() {
        avatarView.isEditable = true
        avatarView.delegate = self
        avatarView.image = profileModel.profilePicture
    }
    
    private func setupSaveButton() {
        saveButton.isEnabled = canSave
        saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func setupScrollView() {
        [usernameTextField,firstNameTextField,weightTextField,heightTextField].forEach { tf in
            fieldStackView.addArrangedSubview(makeTitledField(textField: tf))
        }
    }
    
    private func makeTitledField(textField: ProfileEditorTextField) -> UIStackView {
        textField.delegate = self
        let field = textField.editorField
        switch field {
        case .username:
            textField.text = profileModel.username
        case .firstName:
            textField.text = profileModel.firstName
        case .weight:
            textField.text = String(profileModel.weight)
        case .height:
            textField.text = String(profileModel.height)
        }
        let titleLabel = UILabel()
        titleLabel.text = field.title
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = .Main.green
        
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField])
        stackView.axis = .vertical
        stackView.spacing = CSp.small
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        
        return stackView
    }
}
