//
//  ProfileEditorViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit

final class ProfileEditorViewController: UIViewController {
    
    let profileModel: ProfileModel
    
    private let avatarView = AvatarView()
    
    private let fieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = CSp.small
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private let saveButton = MainButton(title: CSt.saveText)
    
    private let scrollView = UIScrollView()
    
    private var currentTextField: UITextField?
    
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
    
    @objc private func dismissKeyboard() {
        currentTextField?.endEditing(false)
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
            y: view.bounds.height - saveButton.bounds.midY - CSp.xlarge
        )
        
        let fieldStackViewSize = fieldStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        scrollView.bounds.size.height = fieldStackViewSize.height + CSp.small
        scrollView.bounds.size.width = view.bounds.width - CSp.large
        
        scrollView.center = CGPoint(
            x: view.center.x,
            y: avatarView.frame.maxY + scrollView.bounds.height / 2 + CSp.xlarge
        )
        
        fieldStackView.bounds.size = .init(width: scrollView.bounds.width, height: fieldStackViewSize.height)
        fieldStackView.center = CGPoint(x: scrollView.bounds.midX, y: scrollView.bounds.midY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension ProfileEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
        return false
    }
}

// MARK: UI Setup
extension ProfileEditorViewController {
    
    private func setup() {
        view.addSubview(avatarView)
        view.addSubview(saveButton)
        view.addSubview(scrollView)
        view.backgroundColor = .systemBackground
        setupGesture()
        scrollView.addSubview(fieldStackView)
        setupScrollView()
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupScrollView() {
        ProfileEditorField.allCases.forEach { field in
            fieldStackView.addArrangedSubview(makeTitledField(field: field))
        }
    }
    
    private func makeTitledField(field: ProfileEditorField) -> UIStackView {
        let textField = ProfileEditorTextField()
        textField.placeholder = field.placeholder
        textField.keyboardType = field.keyboardType
        textField.autocorrectionType = field.correctionType
        textField.autocapitalizationType = field.capitalizationType
        textField.delegate = self
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
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }
}
