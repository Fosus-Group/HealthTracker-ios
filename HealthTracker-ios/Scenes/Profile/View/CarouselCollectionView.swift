//
//  CarouselCollectionView.swift
//  HealthTracker-ios
//
//  Created by sergey on 01.11.2024.
//

import UIKit

final class CarouselCollectionView: UICollectionView {
    
    let cells: [CarouselCellModel] = [
        Constants.carouselWaterCard,
        Constants.carouselFollowCard,
        Constants.carouselBodyCard
    ]
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = .init(width: 219, height: 319)
        flowLayout.minimumLineSpacing = 24
        flowLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        setup()
    }
    
    private func setup() {
        dataSource = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.reuseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarouselCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: CarouselCell.reuseID,
            for: indexPath
        ) as? CarouselCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(cells[indexPath.item])
        return cell
    }
}
