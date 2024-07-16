//
//  FiveDaysTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit

final class FiveDaysTableViewCell: BaseTableViewCell {
    private let titleLabel = {
        let view = BaseLabel(font: .systemFont(ofSize: 18))
        view.text = "5일 간의 일기예보"
        return view
    }()
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.register(MinMaxTempCollectionViewCell.self, forCellWithReuseIdentifier: MinMaxTempCollectionViewCell.identifier)
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
            $0.height.equalTo(480)
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
    
    func layout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - 40 - sectionSpacing * 2
        layout.itemSize = CGSize(width: width, height: width * 0.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        return layout
    }
    
    
}
