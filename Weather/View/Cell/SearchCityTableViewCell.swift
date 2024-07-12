//
//  SearchCityTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import SnapKit

final class SearchCityTableViewCell: BaseTableViewCell {
    private lazy var hashTagLabel = {
        let view = BaseLabel(font: .systemFont(ofSize: 24))
        view.text = "#"
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel = {
        let view = BaseLabel(font: .boldSystemFont(ofSize: 17))
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var countryLabel = {
        let view = UILabel()
        view.textColor = .secondaryLabel
        view.font = .systemFont(ofSize: 17)
        contentView.addSubview(view)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
    }
    
    override func configureLayout() {
        hashTagLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(hashTagLabel)
            $0.leading.equalTo(hashTagLabel.snp.trailing).offset(10)
            $0.height.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configure(data: CityListElement) {
        titleLabel.text = data.name
        countryLabel.text = data.country
    }

}
