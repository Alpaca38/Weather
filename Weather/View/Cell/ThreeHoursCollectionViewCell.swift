//
//  ThreeHoursCollectionViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit
import SnapKit
import Kingfisher

final class ThreeHoursCollectionViewCell: BaseCollectionViewCell {
    private let timeLabel = BaseLabel(font: .boldSystemFont(ofSize: 18))
    private let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let tempLabel = BaseLabel(font: .boldSystemFont(ofSize: 18))
    
    private lazy var stackView = {
        let view = UIStackView(arrangedSubviews: [timeLabel, imageView, tempLabel])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 4
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.size.equalTo(35)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(data: List?) {
        guard let data else { return }
        timeLabel.text = data.time
        imageView.kf.setImage(with: data.weather.first?.imageURL)
        tempLabel.text = data.main.tempString
    }
}
