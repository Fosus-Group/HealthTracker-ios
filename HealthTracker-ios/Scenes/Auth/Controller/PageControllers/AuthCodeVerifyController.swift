//
//  AuthCodeVerifyController.swift
//  HealthTracker-ios
//
//  Created by sergey on 22.09.2024.
//

import UIKit

final class AuthCodeVerifyController: AuthPageController {
    
    private let hintLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = CSt.verifyPhoneTitle
        lbl.textColor = .Main.green
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = CFs.text
        return lbl
    }()
    
    private let timerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = CSt.refreshCallText
        lbl.textColor = .Main.lightGreen
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = CFs.text
        lbl.isHidden = true
        return lbl
    }()
    
    private let codeView = CodeVerifyView(count: 4)
    
    private var timer: Timer?
    
    override var pageIndex: Int { 2 }
    
    override func nextPage() {
        // send request
//         if success -> nextPage
        mainButton.isEnabled = false
        timerLabel.isHidden = false
        self.countdown = Constants.codeRefreshTime
        setupTimer()
        timer?.fireDate = .now + 1
    }
    
    private lazy var countdown: Int = Constants.codeRefreshTime {
        didSet {
            let minutes = countdown / 60
            let seconds = countdown % 60
            let str = String(format: "%02i:%02i", minutes, seconds)
            self.timerLabel.text = CSt.refreshCallText + " " + str
        }
    }
    
    private func setupTimer() {
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            self.countdown -= 1
            if self.countdown <= 0 {
                timer.invalidate()
                self.mainButton.isEnabled = true
                self.timerLabel.isHidden = true
            }
        }
    }
    
    // MARK: - UI Setup
    
    override func setup() {
        view.addSubview(hintLabel)
        view.addSubview(codeView)
        view.addSubview(timerLabel)
        addGestures()
        super.setup()
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(CSp.multiply4(by: 31).VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.large)
        }
        
        codeView.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(CSp.medium)
            make.centerX.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom).offset(CSp.medium)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.large)
        }
    }
    
    override func setupMainButton() {
        super.setupMainButton()
        mainButton.titleLabel?.adjustsFontSizeToFitWidth = true
        mainButton.configuration?.titleTextAttributesTransformer = .init {
            var out = $0
            out.font = Constants.buttonFont
            return out
        }
    }
    
}

// MARK: - UI Setup
private extension AuthCodeVerifyController {
    
    enum Constants {
        static let buttonFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
        static let codeRefreshTime: Int = 10
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: codeView, action: #selector(codeView.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
}
