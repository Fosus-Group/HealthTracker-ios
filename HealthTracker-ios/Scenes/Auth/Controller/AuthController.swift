//
//  AuthController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit
import SnapKit

final class AuthController: UIViewController {
    
    private let pageViewController = AuthPageViewController()
    private let progressBar: AuthProgessView
    
    var phoneNumber: String? {
//        (pageViewController.pages[1] as? AuthPhoneFieldController)?.phone
        "+79189317604"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.progressBar = AuthProgessView(total: pageViewController.pages.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateProgressBarFrame()
    }
    
    private var buttonOrigin: CGFloat? {
        guard !pageViewController.pageControllers.isEmpty,
              pageViewController.pageControllers[0].buttonOrigin > 0  
        else { return nil }
        return pageViewController.pageControllers[0].buttonOrigin
    }
    
    private func updateProgressBarFrame() {
        progressBar.layer.cornerRadius = progressBar.bounds.height / 2
        if let buttonOrigin {
            progressBar.center.y = buttonOrigin - CSp.large.VAdapted
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension AuthController {
    enum Constants {
        static let progressBarWidth: CGFloat = CSp.multiply4(by: 16)
        static let progressBarHeight: CGFloat = 5
    }
    
    func setup() {
        view.addSubview(progressBar)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        setupPageController()
        setupProgressBar()
        makeConstraints()
        
        pageViewController.didMove(toParent: self)
    }
    
    func setupProgressBar() {
        progressBar.center.x = view.center.x
        progressBar.bounds.size.width = Constants.progressBarWidth
        progressBar.bounds.size.height = Constants.progressBarHeight
    }
    
    func setupPageController() {
        pageViewController.onPageChange = { [unowned progressBar] index in
            progressBar.setProgress(index)
        }
    }
    
    func makeConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
