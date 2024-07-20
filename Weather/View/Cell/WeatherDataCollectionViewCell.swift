//
//  WeatherDataCollectionViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit

final class WeatherDataCollectionViewCell: BaseCollectionViewCell {
    private let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        view.textColor = .secondaryLabel
        return view
    }()
    
    private let contentLabel = {
        let view = BaseLabel(font: .boldSystemFont(ofSize: 28))
        return view
    }()
    
    private lazy var customView = {
        let view = UIView()
        view.backgroundColor = Color.contentBackgroundColor
        view.layer.cornerRadius = 10
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(titleLabel)
        }
    }
    
    func configure(data: String?, category: WeatherDataType?) {
        guard let category , let data else { return }
        titleLabel.text = category.title
        contentLabel.text = data
    }
}
