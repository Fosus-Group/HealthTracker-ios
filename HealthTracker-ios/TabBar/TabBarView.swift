//
//  TabBarView.swift
//  HealthTracker-ios
//
//  Created by sergey on 19.10.2024.
//

import UIKit

final class TabBarView: UIView {
    
    var buttons: [UIButton] = []
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        
        let horizontalPadding = CSp.small * 2
        let widestButton = buttons[selectedIndex].bounds.width
        let availableWidth = bounds.width - widestButton - horizontalPadding
        
        for i in 0..<buttons.count {
            if i == selectedIndex {
                continue
            }
            buttons[i].bounds.size.width = availableWidth / 3
        }
        
        for i in 0..<buttons.count {
            if i == 0 {
                buttons[i].frame.origin.x = CSp.small
            } else {
                buttons[i].frame.origin.x = buttons[i - 1].frame.maxX + CSp.small
            }
//            buttons[i].bounds.size.width = availableWidth / 3
        }
    }
    
    private func setup() {
        backgroundColor = .Main.green
        setButtons()
//        makeConstraints()
    }
    
    private func findMaxWidth() -> CGSize {
        return .zero
    }
    
    private func setButtons() {
        [
            TabBarButtonModel(title: "Профиль", image: .init(systemName: "person")),
            TabBarButtonModel(title: "Статистика", image: .init(systemName: "chart.bar")),
            TabBarButtonModel(title: "Календарь", image: .init(systemName: "calendar")),
            TabBarButtonModel(title: "Капля", image: .init(systemName: "drop")),
        ].enumerated().forEach { index, model in
            let btn = makeButton(model: model)
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(btn)
            addSubview(btn)
        }
        buttons.first?.isSelected = true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        selectedIndex = sender.tag
    }
    
    private func makeButton(model: TabBarButtonModel) -> UIButton {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .systemFont(ofSize: 13, weight: .bold)
        var config = UIButton.Configuration.plain()
        config.image = model.image
        config.title = model.title
        config.imagePlacement = .leading
        config.imagePadding = CSp.min
        config.cornerStyle = .capsule
        let btn = UIButton(configuration: config)
        btn.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.background.backgroundColor = .Main.lightGreen
                btn.configuration?.baseForegroundColor = .Main.green
                btn.configuration?.title = model.title
                btn.configuration?.attributedTitle = AttributedString(model.title, attributes: attributeContainer)
            case .normal:
                btn.configuration?.background.backgroundColor = .Main.green
                btn.configuration?.baseForegroundColor = .white
                btn.configuration?.attributedTitle = nil
            default:
                break
            }
        }
        return btn
    }
    
    
    private func makeConstraints() {
        for i in 0..<buttons.count {
            buttons[i].snp.makeConstraints { make in
                let spacing = CSp.small
//                make.verticalEdges.equalToSuperview().inset(spacing)
                make.centerY.equalToSuperview()
                
                if i == 0 {
                    make.leading.equalToSuperview().inset(spacing)
                } else if i == buttons.count {
                    make.trailing.equalToSuperview().inset(spacing)
                } else {
                    make.leading.equalTo(buttons[i-1].snp.trailing).offset(spacing)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
