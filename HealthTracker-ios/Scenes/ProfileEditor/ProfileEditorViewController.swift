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
        stackView.alignment = .leading
        return stackView
    }()
    
    private let saveButton = MainButton(title: CSt.saveText)
    
    private let scrollView = UIScrollView()
    
    init(profileModel: ProfileModel) {
        self.profileModel = profileModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame
        
        avatarView.center = CGPoint(
            x: view.center.x,
            y: safeAreaFrame.minY + avatarView.bounds.midY// + CSp.xlarge
        )
        
        saveButton.bounds.size = .init(width: view.bounds.width - CSp.large, height: 64)
        saveButton.center = CGPoint(
            x: view.center.x,
            y: view.bounds.height - saveButton.bounds.midY - CSp.xlarge
        )
        
        let fieldStackViewSize = fieldStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        scrollView.bounds.size.height = fieldStackViewSize.height
        scrollView.bounds.size.width = view.bounds.width - CSp.large
        
        scrollView.center = CGPoint(
            x: view.center.x,
            y: avatarView.frame.maxY + scrollView.bounds.height / 2 + CSp.xlarge
        )
        
        fieldStackView.frame = scrollView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (tabBarController as? MainTabBarController)?.tabbarView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (tabBarController as? MainTabBarController)?.tabbarView.isHidden = false
    }
    
    private func setup() {
        view.addSubview(avatarView)
        view.addSubview(saveButton)
        view.addSubview(scrollView)
        view.backgroundColor = .systemBackground
        scrollView.addSubview(fieldStackView)
        setupScrollView()
    }
    
    private func setupScrollView() {
        for placeholder in ["name", "weight", "height", "age"] {
            fieldStackView.addArrangedSubview(makeField(placeholder: placeholder))
        }
        scrollView.backgroundColor = .red
    }
    
    
    private func makeField(/*title: String, */placeholder: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .headline)
        field.textColor = .label
        return field
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
