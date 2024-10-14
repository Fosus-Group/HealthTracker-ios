//
//  AuthFirstPageController.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class AuthFirstPageController: AuthPageController {
    
    private let backgroundImage = UIImageView(image: .Pictures.runningMan)
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = CSt.onboardingTitle
        lbl.font = CFs.button
        lbl.textAlignment = .center
        lbl.textColor = .Main.green
        return lbl
    }()
    
    private let captionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = CSt.onboardignCaption
        lbl.font = .systemFont(ofSize: 13, weight: .bold)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.textColor = .Main.lightGreen
        return lbl
    }()
    
    override func setup() {
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(captionLabel)
        setupBackgroundImage()
        super.setup()
    }
    
    override func setupShapeLayer() {
        shapeLayer.isHidden = true
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(CSp.xlarge.VAdapted)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.imageSize.adapted)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(CSp.small.VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(CSp.multiply4(by: 6).VAdapted)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(CSp.medium.HAdapted)
        }
    }
}

private extension AuthFirstPageController {
    enum Constants {
        static let imageSize = CGSize(width: 213, height: 289)
    }
    private func setupBackgroundImage() {
        backgroundImage.contentMode = .scaleAspectFit
    }
}
