//
//  AuthController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit
import SnapKit

final class AuthController: UIViewController {
    
    private let pageController = AuthPageViewController()
    private let progressBar: AuthProgessView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.progressBar = AuthProgessView(total: pageController.pages.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateProgressBarFrame()
    }
    
    func nextPage() {
        pageController.nextPage()
    }
    
    private var buttonOrigin: CGFloat? {
        guard !pageController.pageControllers.isEmpty,
              pageController.pageControllers[0].buttonOrigin > 0  
        else { return nil }
        return pageController.pageControllers[0].buttonOrigin
    }
    
    func updateProgressBarFrame() {
        progressBar.layer.cornerRadius = progressBar.bounds.height / 2
        if let buttonOrigin {
            progressBar.center.y = buttonOrigin - CSp.large.VAdapted
        }
    }
}

// MARK: - UI
private extension AuthController {
    enum Constants {
        static let progressBarWidth: CGFloat = CSp.multiply4(by: 16)
        static let progressBarHeight: CGFloat = 5
    }
    
    func setup() {
        setupPageController()
        setupProgressBar()
        makeConstraints()
    }
    
    func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.center.x = view.center.x
        progressBar.bounds.size.width = Constants.progressBarWidth
        progressBar.bounds.size.height = Constants.progressBarHeight
    }
    
    func setupPageController() {
        addChild(pageController)
        view.addSubview(pageController.view)
        
        pageController.onPageChange = { [unowned progressBar] index in
            progressBar.setProgress(index)
        }
    }
    
    func makeConstraints() {
        
        pageController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageController.didMove(toParent: self)
    }
}
