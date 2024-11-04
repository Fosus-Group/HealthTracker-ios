//
//  CarouselCell.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit

final class CarouselCell: UICollectionViewCell {
    
    static let reuseID: String = #function
    
    private let imageView = UIImageView()
    private let titleLabel = CarouselCell.makeLabel(withSize: 20)
    private let bodyLabel = CarouselCell.makeLabel(withSize: 16)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func configure(_ model: CarouselCellModel) {
        titleLabel.text = model.title
        bodyLabel.text = model.body
        imageView.image = model.image
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        
        makeConstraints()
    }
    
    private static func makeLabel(withSize size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: size).adapted
        label.textColor = .Main.green
        label.numberOfLines = 0
        return label
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(CSp.medium)
            make.top.equalToSuperview().inset(CSp.large)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(CSp.medium)
            make.top.equalTo(titleLabel.snp.bottom).offset(CSp.small)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
