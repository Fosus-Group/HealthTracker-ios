//
//  AuthPageController.swift
//  HealthTracker-ios
//
//  Created by sergey on 10.10.2024.
//

import UIKit


class AuthPageController: UIViewController {
    
    // MARK: - Properties
    
    let mainButton: MainButton
    let shapeLayer = CALayer()
    
    var pageIndex: Int { 0 }
    
    var buttonOrigin: CGFloat {
        self.mainButton.frame.origin.y
    }
    
    init(mainButton: MainButton) {
        self.mainButton = mainButton
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = CGSize(
            width: view.frame.width,
            height: view.frame.height * Constants.shapeHeightRatio
        )
        shapeLayer.frame = .init(origin: .zero, size: size)
    }
    
    @objc func nextPage() {
        (parent as? AuthPageViewController)?.nextPage()
    }
    
    // MARK: - UI setup
    
    func setup() {
        view.addSubview(mainButton)
        view.layer.insertSublayer(shapeLayer, at: 0)
        setupShapeLayer()
        setupMainButton()
        makeConstraints()
    }
    
    func setupMainButton() {
        mainButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    func setupShapeLayer() {
        shapeLayer.contents = UIImage.Pictures.shapepath.cgImage
    }
    
    func makeConstraints() {
        view.safeAreaLayoutGuide.bottomAnchor.constraint(
            equalTo: mainButton.bottomAnchor,
            constant: CSp.multiply4(by: 25).VAdapted
        ).isActive = true
        mainButton.snp.makeConstraints { make in
            make.leading.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(CSp.large.HAdapted)
            make.trailing.greaterThanOrEqualTo(view.safeAreaLayoutGuide).inset(CSp.large.HAdapted)
            make.centerX.equalToSuperview()
            make.height.equalTo(HealthTracker_ios.Constants.authButtonHeight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthPageController {
    enum Constants {
        static let shapeHeightRatio: CGFloat = 0.574
    }
}
