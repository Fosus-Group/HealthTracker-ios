//
//  TabBarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

protocol TabBarControllerProtocol: UITabBarController {
    
}

final class TabBarView: UIView {
    
    private var buttons: [UIButton] = []
    
    weak var tabBarController: TabBarControllerProtocol?
    
    private var selectedBackgroundLayer = CALayer()
    
    var selectedIndex = 0
    
    private var layoutPassComplete = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .layoutSubviews) { [self] in
            calculateButtonFrames()
        }
        if !layoutPassComplete {
            layoutPassComplete = true
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons[selectedIndex].isSelected = false
        sender.isSelected = true
        selectedIndex = sender.tag
        layoutPassComplete = false
        tabBarController?.selectedIndex = selectedIndex
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit TabBarView")
    }
}

// MARK: UI setup
extension TabBarView {
    private func setup() {
        backgroundColor = .Main.green
        setButtons()
        setupMovingLayer()
    }
    
    private func setupMovingLayer() {
        layer.insertSublayer(selectedBackgroundLayer, at: 0)
        selectedBackgroundLayer.backgroundColor = UIColor.Main.sand.cgColor
        selectedBackgroundLayer.masksToBounds = true
    }
    
    private func calculateButtonFrames() {
        let selectedButton = buttons[selectedIndex]
        let selectedButtonSize = selectedButton.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        
        let width = bounds.width
        let horizontalPadding = CSp.small * 2
        let spacing = CSp.small * CGFloat(buttons.count - 1)
        let availableWidth = width - horizontalPadding - spacing - selectedButtonSize.width
        
        let otherButtonsWidth = availableWidth / CGFloat(buttons.count - 1)
        
        for index in 0..<buttons.count {
            let currentButton = buttons[index]
            if index == 0 {
                currentButton.frame.origin.x = CSp.small
            } else {
                let xOffset = buttons[index - 1].frame.maxX + CSp.small
                currentButton.frame.origin.x = xOffset
            }
            
            currentButton.center.y = bounds.midY
            
            if currentButton.isSelected {
                currentButton.bounds.size = selectedButtonSize
            } else {
                currentButton.bounds.size = CGSize(
                    width: otherButtonsWidth,
                    height: selectedButtonSize.height
                )
            }
        }
        
        selectedBackgroundLayer.frame = selectedButton.frame
        selectedBackgroundLayer.cornerRadius = selectedBackgroundLayer.bounds.height / 2
    }
    
    private func setButtons() {
        self.buttons = TabBarButton.allCases.map { button in
            let model = TabBarButtonModel(title: button.title, image: button.icon)
            let btn = makeButton(model: model)
            btn.tag = button.rawValue
            if button.rawValue == 0 { btn.isSelected = true }
            
            addSubview(btn)
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            
            return btn
        }
    }
    
    private func makeButton(model: TabBarButtonModel) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        config.image = model.image
        config.imagePlacement = .leading
        config.imagePadding = CSp.min
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .systemFont(ofSize: 13, weight: .bold)
        let attributedTitle = AttributedString(model.title, attributes: attributeContainer)
        config.attributedTitle = attributedTitle
        let btn = UIButton(configuration: config)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                config.baseForegroundColor = .Main.green
                config.attributedTitle = attributedTitle
            case .normal:
                config.baseForegroundColor = .white
                config.attributedTitle = nil
            default:
                break
            }
            btn.configuration = config
        }
        
        return btn
    }
}
