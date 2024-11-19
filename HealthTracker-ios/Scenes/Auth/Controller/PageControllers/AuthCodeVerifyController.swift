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
    
    private var countdown: Int = Constants.codeRefreshTime {
        didSet {
            let minutes = countdown / 60
            let seconds = countdown % 60
            let str = String(format: "%02i:%02i", minutes, seconds)
            self.timerLabel.text = CSt.refreshCallText + " " + str
        }
    }
    
    private func verifyPhoneNumber(code: String) async throws -> AuthVerifyDTO {
        guard let phone = (parent?.parent as? AuthController)?.phoneNumber else {
            throw API.AuthError.phoneNotFound
        }
        let auth = try await authService.verifyPhoneNumber(phone: phone, code: code)
        return auth
    }
    
    override func mainButtonTapped() {
        guard mainButton.isEnabled else { return }
        guard let phone = (parent?.parent as? AuthController)?.phoneNumber else { return }
        setupTimer()
        Task {
            await authService.requestPhoneCall(phone: phone)
        }
    }
    
    override func prevPage() {
        guard timer == nil else { return }
        codeView.clearCode()
        super.prevPage()
    }
    
    private func setupTimer() {
        guard timer == nil else { return }
        mainButton.isEnabled = false
        timerLabel.isHidden = false
        timer?.fireDate = .now + 1
        timer = .scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            self.countdown -= 1
            if self.countdown <= 0 {
                timer.invalidate()
                self.timer = nil
                self.mainButton.isEnabled = true
                self.timerLabel.isHidden = true
                self.countdown = Constants.codeRefreshTime
            }
        }
    }
    
    // MARK: - UI Setup
    
    override func setup() {
        view.addSubview(hintLabel)
        view.addSubview(codeView)
        view.addSubview(timerLabel)
        addGestures()
        setupCodeView()
        setupTimer()
        super.setup()
    }
    
    private func setupCodeView() {
        codeView.delegate = self
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

extension AuthCodeVerifyController: CodeVerifyViewDelegate {
    func didFillCode(_ code: String) {
        parent?.view.isUserInteractionEnabled = false
        
        Task {
            do {
                let authDTO = try await verifyPhoneNumber(code: code)
                if authDTO.success {
                    // MARK: TODO
                    // save token
                    // add coordinator
                    UserDefaults.standard.set(true, forKey: "isAuthorized")
                    let authorization = Authorization.fromDTO(authDTO)
                    UserDefaults.standard.set(authorization.accessToken, forKey: "accessToken")
                    UserDefaults.standard.set(authorization.refreshToken, forKey: "refreshToken")
                    let token = Token.fromDTO(authorization)
                    await NetworkingService.shared.saveToken(token)
                    UIApplication.shared.window?.rootViewController = MainTabBarController()
                } else {
                    parent?.view.isUserInteractionEnabled = true
                }
            } catch {
                self.showAlert(error: error)
                parent?.view.isUserInteractionEnabled = true
            }
        }
    }
}

// MARK: - UI Setup
private extension AuthCodeVerifyController {
    
    enum Constants {
        static let buttonFont: UIFont = .systemFont(ofSize: 20, weight: .bold)
        static let codeRefreshTime: Int = 20
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: codeView, action: #selector(codeView.endEditing(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
}



extension UIViewController {
    func showAlert(error: Error) {
        let title: String
        let message: String
        if let serverError = error as? ServerError {
            title = serverError.title
            message = serverError.text
        } else {
            title = "Error"
            message = error.localizedDescription
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
