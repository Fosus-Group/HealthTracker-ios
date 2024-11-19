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
    
    private let saveButton = MainButton(title: CSt.saveText)
    
    private let usernameTextField = ProfileEditorTextField(fieldType: .username)
    private let firstNameTextField = ProfileEditorTextField(fieldType: .firstName)
    private let weightTextField = ProfileEditorTextField(fieldType: .weight)
    private let heightTextField = ProfileEditorTextField(fieldType: .height)
    
    private let titledFieldStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = CSp.medium
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private var textFields: [ProfileEditorTextField] {
        [usernameTextField, firstNameTextField, weightTextField, heightTextField]
    }
    
    var canSave: Bool {
        for textField in textFields {
            guard let text = textField.text, !text.isEmpty else { return false }
        }
        
        return true
    }
    
    var onSave: ((ProfileModel) -> Void)?
    
    private var editingTextFieldIndex: Int = 0
    
    init(profileModel: ProfileModel) {
        self.profileModel = profileModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutFrames()
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
            phoneNumber: profileModel.phoneNumber,
            username: username,
            firstName: firstName,
            weight: weight,
            height: height,
            profilePicture: avatarView.image
        )
        
        
        profileModel.saveToDisk()
        navigationController?.popViewController(animated: true)
        
        onSave?(profileModel)
    }
    
    @objc private func dismissKeyboard() {
        guard editingTextFieldIndex < textFields.count else { return }
        textFields[editingTextFieldIndex].endEditing(false)
    }
    
    private func layoutFrames() {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension ProfileEditorViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editingTextFieldIndex = textField.tag
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = canSave
        
        guard let editorTextField = textField as? ProfileEditorTextField else { return }
        guard let text = textField.text else { return  }
        
        switch editorTextField.fieldType {
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
        
        switch editorTextField.fieldType {
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
                        let imageRenderer = UIGraphicsImageRenderer(size: .init(width: 100, height: 100))
                        let newImage = imageRenderer.image { context in
                            let rect = CGRect(origin: .zero, size: .init(width: 100, height: 100))
                            image.draw(in: rect)
                        }
                        avatarView.image = newImage
                    }
                }
            }
        }
    }
}

// MARK: UI Setup
extension ProfileEditorViewController {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(avatarView)
        view.addSubview(titledFieldStack)
        view.addSubview(saveButton)
        setupFieldStackView()
        setupAvtarView()
        setupSaveButton()
        setupGestures()
        makeConstraints()
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
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    
    private func setupFieldStackView() {
        [usernameTextField,firstNameTextField,weightTextField,heightTextField].forEach { tf in
            titledFieldStack.addArrangedSubview(makeTitledField(textField: tf))
        }
    }
    
    private func makeTitledField(textField: ProfileEditorTextField) -> UIStackView {
        textField.delegate = self
        let field = textField.fieldType
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
    
    private func makeConstraints() {
        titledFieldStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(CSp.medium)
            make.top.equalTo(avatarView.snp.bottom).offset(CSp.xlarge)
        }
    }
}
