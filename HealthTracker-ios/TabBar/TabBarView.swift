//
//  TabBarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

protocol TabBarControllerProtocol: UITabBarController {}

final class TabBarView: UIView {
    
    private var buttons: [UIButton] = []
    
    weak var tabBarController: TabBarControllerProtocol?
    
    private var selectedBackgroundLayer = CALayer()
    
    var selectedIndex = 0 {
        didSet {
            buttons[oldValue].isSelected = false
            buttons[selectedIndex].isSelected = true
//            sender.isSelected = true
            selectedIndex = buttons[selectedIndex].tag
            tabBarController?.selectedIndex = selectedIndex
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private lazy var hasNotch = (self.window?.windowScene?.delegate as? SceneDelegate)?.deviceHasNotch ?? false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hasNotch {
            layer.cornerRadius = bounds.height / 2
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .layoutSubviews) { [self] in
            calculateButtonFrames()
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        buttons[selectedIndex].isSelected = false
        sender.isSelected = true
        selectedIndex = sender.tag
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
        let selectedButtonSize = selectedButton.intrinsicContentSize
        let width = bounds.width
        let horizontalPadding = CSp.small * 2
        let spacing = CSp.small * CGFloat(buttons.count - 1)
        let availableWidth = width - horizontalPadding - spacing - selectedButtonSize.width
        
        let otherButtonsWidth = availableWidth / CGFloat(buttons.count - 1)
        
        for index in 0..<buttons.count {
            let currentButton = buttons[index]
            
            if currentButton.isSelected {
                currentButton.bounds.size = selectedButtonSize
            } else {
                currentButton.bounds.size = CGSize(
                    width: otherButtonsWidth,
                    height: selectedButtonSize.height
                )
            }
            
            let center: CGPoint
            if index == 0 {
                center = CGPoint(x: CSp.small + currentButton.bounds.midX, y: bounds.midY)
            } else {
                let xOffset = buttons[index - 1].frame.maxX + CSp.small + currentButton.bounds.midX
                center = CGPoint(x: xOffset, y: bounds.midY)
            }
            
            currentButton.center = center
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
        btn.clipsToBounds = true
        btn.imageView?.contentMode = .scaleAspectFit
        btn.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.baseForegroundColor = .Main.green
                btn.configuration?.attributedTitle = attributedTitle
            case .normal:
                btn.configuration?.baseForegroundColor = .white
                btn.configuration?.attributedTitle = nil
            default:
                break
            }
        }
        
        return btn
    }
}
