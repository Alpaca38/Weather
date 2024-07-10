//
//  ViewController.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit
import SnapKit

final class WeatherViewController: BaseViewController {
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
        self.view.addSubview(view)
        return view
    }()
    private lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        self.view.addSubview(view)
        return view
    }()
    private lazy var mapButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        view.setImage(UIImage(systemName: "map", withConfiguration: imageConfig), for: .normal)
        view.tintColor = .white
        view.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        return view
    }()
    private lazy var citySearchButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        view.setImage(UIImage(systemName: "list.bullet", withConfiguration: imageConfig), for: .normal)
        view.tintColor = .white
        view.addTarget(self, action: #selector(citySearchButtonTapped), for: .touchUpInside)
        return view
    }()
    private lazy var bottomView = {
        let view = UIView()
        view.addSubview(mapButton)
        view.addSubview(citySearchButton)
        view.backgroundColor = Color.contentBackgroundColor
        self.view.addSubview(view)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backgroundColor
        viewModel.inputViewDidLoadTriggger.value = ()
        bindData()
    }
    
    override func configureLayout() {
        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        mapButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        citySearchButton.snp.makeConstraints {
            $0.top.equalTo(mapButton)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

private extension WeatherViewController {
    func bindData() {
        viewModel.outputCurrentWeatherData.bind { [weak self] in
            guard let self else { return }
            cityLabel.text = $0?.name
            tempLabel.text = $0?.main.tempString
            descriptionLabel.text = $0?.weather.first?.description
            tempMinMaxLabel.text = $0?.main.tempMinMaxString
        }
    }
    
    @objc func mapButtonTapped() {
        
    }
    
    @objc func citySearchButtonTapped() {
        
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
