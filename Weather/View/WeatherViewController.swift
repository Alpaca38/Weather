//
//  ViewController.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import UIKit
import MapKit
import SnapKit
import Toast

private enum TableViewCellType: Int, CaseIterable {
    case threehours
    case fivedays
    case map
    case weatherData
    
    var height: CGFloat {
        switch self {
        case .threehours:
            return 220
        case .fivedays:
            return 420
        case .map:
            return 270
        case .weatherData:
            return 420
        }
    }
}

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
//        self.view.addSubview(view)
        return view
    }()
    private lazy var tableView = {
        let view = UITableView()
        view.backgroundColor = Color.backgroundColor
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        view.tableHeaderView = topView
        view.register(ThreeHoursTableViewCell.self, forCellReuseIdentifier: ThreeHoursTableViewCell.identifier)
        view.register(FiveDaysTableViewCell.self, forCellReuseIdentifier: FiveDaysTableViewCell.identifier)
        view.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        view.register(WeatherDataTableViewCell.self, forCellReuseIdentifier: WeatherDataTableViewCell.identifier)
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
//        topView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide)
//            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
//        }
       
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
        
        tableView.snp.makeConstraints {
//            $0.top.equalTo(topView.snp.bottom).offset(20)
//            $0.horizontalEdges.equalTo(topView)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(bottomView.snp.top)
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
        
        viewModel.outputForeCastData.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
        
        viewModel.outputWeekData.bind { [weak self] _ in
            guard let self else { return }
            tableView.reloadData()
        }
        
        viewModel.outputErrorMessage.bind { [weak self] message in
            guard let self, let message else { return }
            view.makeToast(message, duration: 3, position: .center)
        }
    }
    
    @objc func mapButtonTapped() {
        let vc = MapViewController()
        vc.sendCoord = { [weak self] coord in
            guard let self else { return }
            viewModel.inputCityCoord.value = coord
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func citySearchButtonTapped() {
        let vc = SearchCityViewController()
        vc.sendCityID = { [weak self] id in
            guard let self else { return }
            viewModel.inputCityID.value = id
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = TableViewCellType.allCases[indexPath.row]
        switch cellType {
        case .threehours:
            let cell = tableView.dequeueReusableCell(withIdentifier: ThreeHoursTableViewCell.identifier, for: indexPath) as! ThreeHoursTableViewCell
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        case .fivedays:
            let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysTableViewCell.identifier, for: indexPath) as! FiveDaysTableViewCell
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as! MapTableViewCell
            cell.mapView.delegate = self
            cell.configure(data: viewModel.outputCurrentWeatherData.value)
            return cell
        case .weatherData:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDataTableViewCell.identifier, for: indexPath) as! WeatherDataTableViewCell
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = TableViewCellType.allCases[indexPath.row]
        return cellType.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}

extension WeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.identifier)
        guard let humidity = viewModel.outputCurrentWeatherData.value?.main.humidity else { return MKAnnotationView() }
        annotationView.glyphText = "\(humidity)"
        return annotationView
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let list = viewModel.outputForeCastData.value?.list else {
            return 0
        }
        switch collectionView.tag {
        case 0:
            return list.count
        case 1:
            return viewModel.outputWeekData.value.count
        case 3:
            return WeatherDataType.allCases.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThreeHoursCollectionViewCell.identifier, for: indexPath) as! ThreeHoursCollectionViewCell
            let data = viewModel.outputForeCastData.value?.list[indexPath.item]
            cell.configure(data: data)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MinMaxTempCollectionViewCell.identifier, for: indexPath) as! MinMaxTempCollectionViewCell
            let data = viewModel.outputWeekData.value[indexPath.item]
            cell.configure(data: data, index: indexPath.item)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDataCollectionViewCell.identifier, for: indexPath) as! WeatherDataCollectionViewCell
            let type = WeatherDataType(rawValue: indexPath.item)
            cell.configure(data: viewModel.outputCurrentWeatherData.value, category: type)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
