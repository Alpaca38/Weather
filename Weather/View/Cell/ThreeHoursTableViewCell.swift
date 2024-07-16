//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit
import SnapKit

final class ThreeHoursTableViewCell: BaseTableViewCell {
    private let titleLabel = {
        let view = BaseLabel(font: .systemFont(ofSize: 18))
        view.text = "3시간 간격의 일기예보"
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.backgroundColor = .clear
        view.register(ThreeHoursCollectionViewCell.self, forCellWithReuseIdentifier: ThreeHoursCollectionViewCell.identifier)
        return view
    }()
    
    private lazy var customView = {
        let view = UIView()
        view.backgroundColor = Color.contentBackgroundColor
        view.layer.cornerRadius = 10
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        customView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

private extension ThreeHoursTableViewCell {
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - sectionSpacing * 2 - cellSpacing * 3
        layout.itemSize = CGSize(width: width/4, height: width/4 * 1.3)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
}
