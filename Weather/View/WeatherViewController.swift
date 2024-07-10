//
//  ViewController.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit
import SnapKit

final class WeatherViewController: BaseViewController {
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
        self.view.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backgroundColor
    }
    
    override func configureLayout() {
        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }


}

