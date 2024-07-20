//
//  WeatherTableViewHeaderView.swift
//  Weather
//
//  Created by 조규연 on 7/16/24.
//

import UIKit
import SnapKit

final class CurrentWeatherCollectionViewCell: UICollectionViewCell {
    private let viewModel = WeatherViewModel()
    private let cityLabel = BaseLabel(font: .systemFont(ofSize: 32))
    private let tempLabel = BaseLabel(font: .systemFont(ofSize: 70))
    private let descriptionLabel = BaseLabel(font: .systemFont(ofSize: 24))
    private let tempMinMaxLabel = BaseLabel(font: .systemFont(ofSize: 23))
    private lazy var topView = {
        let view = UIStackView(arrangedSubviews: [cityLabel, tempLabel, descriptionLabel, tempMinMaxLabel])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 4
        contentView.addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(data: CurrentWeather) {
        cityLabel.text = data.name
        tempLabel.text = data.main.tempString
        descriptionLabel.text = data.weather.first?.description
        tempMinMaxLabel.text = data.main.tempMinMaxString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
