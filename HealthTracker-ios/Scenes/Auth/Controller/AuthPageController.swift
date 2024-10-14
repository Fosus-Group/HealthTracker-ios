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
        guard mainButton.isEnabled else { return }
        (parent as? AuthPageViewController)?.nextPage()
    }
    
    func prevPage() {
        (parent as? AuthPageViewController)?.prevPage()
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            prevPage()
        case .left:
            nextPage()
        default:
            return
        }
    }
    
    // MARK: - UI setup
    
    func setup() {
        view.addSubview(mainButton)
        view.layer.insertSublayer(shapeLayer, at: 0)
        addSwipeGestures()
        setupShapeLayer()
        setupMainButton()
        makeConstraints()
    }
    
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        swipeLeft.direction = .left
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
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
