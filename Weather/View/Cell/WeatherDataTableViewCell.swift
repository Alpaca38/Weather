//
//  WeatherDataTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit

final class WeatherDataTableViewCell: BaseTableViewCell {
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.backgroundColor = .clear
        view.register(WeatherDataCollectionViewCell.self, forCellWithReuseIdentifier: WeatherDataCollectionViewCell.identifier)
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(400)
        }
    }
}

private extension WeatherDataTableViewCell {
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - sectionSpacing * 2 - cellSpacing * 1
        layout.itemSize = CGSize(width: width/2, height: width/2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        return layout
    }
}
