//
//  AuthPageViewController.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

final class AuthPageViewController: UIPageViewController {
    
    private var isSliding = false
    
    var onPageChange: (Int) -> Void = {_ in }
    
    let pages: [AuthPageController] = [
        AuthFirstPageController(mainButton: MainButton(title: CSt.buttonStart)),
        AuthPhoneFieldController(mainButton: MainButton(title: CSt.buttonLogin)),
        AuthCodeVerifyController(mainButton: MainButton(title: CSt.requestNewCodeText))
    ]
    
    var currentIndex: Int {
        return pages.firstIndex(of: pageControllers[0]) ?? 0
    }
    
    var pageControllers: [AuthPageController] {
        self.viewControllers as! [AuthPageController]
    }
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func nextPage() {
        guard !isSliding else { return }
        guard currentIndex + 1 < pages.count else { return }
        let nextVC = pages[currentIndex + 1]
        isSliding = true
        setViewControllers([nextVC], direction: .forward, animated: true) { finished in
            self.isSliding = !finished
        }
        onPageChange(currentIndex)
    }
    
    func prevPage() {
        guard !isSliding else { return }
        guard !pages.isEmpty, currentIndex - 1 > -1 else { return }
        let prevVC = pages[currentIndex - 1]
        isSliding = true
        setViewControllers([prevVC], direction: .reverse, animated: true) { finished in
            self.isSliding = !finished
        }
        onPageChange(currentIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AuthPageViewController {
    func setup() {
        isDoubleSided = false
    }
}
