//
//  TabBarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

final class TabBarView: UIView {
    
    var buttons: [UIButton] = []
    
    var movingLayer = CALayer()
    
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        UIView.animate(withDuration: 0.25) { [self] in
            move(toIndex: selectedIndex)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        selectedIndex = sender.tag
        setNeedsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI setup
extension TabBarView {
    private func setup() {
        backgroundColor = .Main.green
        setButtons()
        setupMovingLayer()
    }
    
    fileprivate func setupMovingLayer() {
        layer.insertSublayer(movingLayer, at: 0)
        movingLayer.backgroundColor = UIColor.Main.sand.cgColor
        movingLayer.masksToBounds = true
    }
    
    private func updateButton() {
        for button in self.buttons {
            switch button.state {
            case .selected:
                button.configuration?.baseForegroundColor = .Main.green
            case .normal:
                button.configuration?.baseForegroundColor = .white
                button.configuration?.attributedTitle = nil
            default:
                break
            }
        }
    }
    
    private func move(toIndex index: Int) {
        let horizontalPadding = CSp.small * 2
        let spacing = CSp.small * CGFloat(buttons.count - 1)
        let width = bounds.width
        let selectedButton = buttons[selectedIndex]
        let selectedButtonSize = selectedButton.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        
        let availableWidth = width - horizontalPadding - spacing - selectedButtonSize.width
        
        let otherButtonWidth = availableWidth / CGFloat(buttons.count - 1)
        
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
                currentButton.bounds.size = .init(
                    width: otherButtonWidth,
                    height: selectedButtonSize.height
                )
            }
            
        }
        
        // MARK: - background layer
        movingLayer.frame = selectedButton.frame
        movingLayer.cornerRadius = movingLayer.bounds.height / 2
    }
    
    private func setButtons() {
        [
            TabBarButtonModel(title: "Профиль", imageName: "person"),
            TabBarButtonModel(title: "Статистика", imageName: "chart.bar"),
            TabBarButtonModel(title: "Календарь", imageName: "calendar"),
            TabBarButtonModel(title: "Капля", imageName: "drop"),
        ].enumerated().forEach { index, model in
            let btn = makeButton(model: model)
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(btn)
            addSubview(btn)
        }
        buttons.first?.isSelected = true
    }
    
    private func makeButton(model: TabBarButtonModel) -> UIButton {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .systemFont(ofSize: 13, weight: .bold)
        var config = UIButton.Configuration.plain()
        config.title = model.title
        config.imagePlacement = .leading
        config.imagePadding = CSp.min
        config.cornerStyle = .capsule
        config.background.backgroundColor = .clear
        let btn = UIButton(configuration: config)
        let selectedImage = UIImage(systemName: model.imageName + ".fill")
        let normalImage = UIImage(systemName: model.imageName)
        btn.configurationUpdateHandler = { [weak self] btn in
            UIView.transition(with: btn, duration: 0.25) {
                switch btn.state {
                case .selected:
                    btn.configuration?.image = selectedImage ?? normalImage
                    btn.configuration?.baseForegroundColor = .Main.green
                    btn.configuration?.title = model.title
                    btn.configuration?.attributedTitle = AttributedString(model.title, attributes: attributeContainer)
                case .normal:
                    btn.configuration?.image = normalImage
                    btn.configuration?.baseForegroundColor = .white
                    btn.configuration?.attributedTitle = nil
                default:
                    break
                }
            }
            
            guard let self else { return }
            self.setNeedsLayout()
        }
        return btn
    }
}
