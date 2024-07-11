//
//  MinMaxTempTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit
import Kingfisher

final class MinMaxTempCollectionViewCell: BaseCollectionViewCell {
    private let dayLabel = BaseLabel(font: .systemFont(ofSize: 22))
    private let iconImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let tempMinLabel = BaseLabel(font: .systemFont(ofSize: 22))
    private let tempMaxLabel = BaseLabel(font: .systemFont(ofSize: 22))
    
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [dayLabel, iconImageView, tempMinLabel, tempMaxLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(35)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(data: DayWeather, index: Int) {
        if index == 0 {
            dayLabel.text = "오늘"
        } else {
            dayLabel.text = data.day
        }
        iconImageView.kf.setImage(with: data.weatherIconURL)
        tempMinLabel.text = data.tempMinString
        tempMaxLabel.text = data.tempMaxString
    }
}
