//
//  MainButton.swift
//  HealthTracker-ios
//
//  Created by sergey on 21.09.2024.
//

import UIKit

final class MainButton: UIButton {
    
    let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .Main.green
        config.cornerStyle = .capsule
        config.baseForegroundColor = .Main.light
        config.contentInsets = .make(Array(repeating: CSp.medium, count: 4))
        config.title = title
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = CFs.button
            return outgoing
        }
        configurationUpdateHandler = { button in
            switch button.state {
            case .normal:
                button.configuration?.background.backgroundColor = .Main.green
                button.configuration?.baseForegroundColor = .Main.light
            case .disabled:
                button.configuration?.background.backgroundColor = .Main.sand
                button.configuration?.baseForegroundColor = .Main.lightGreen
            default:
                break
            }
        }
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
