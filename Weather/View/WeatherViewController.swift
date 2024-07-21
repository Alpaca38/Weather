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

private enum WeatherSection: Int, CaseIterable {
    case currentWeather
    case threehours
    case fivedays
    case map
    case weatherData
    
    var headerTitle: String {
        switch self {
        case .currentWeather:
            return ""
        case .threehours:
            return "3시간 간격의 일기예보"
        case .fivedays:
            return "5일 간의 일기예보"
        case .map:
            return "습도"
        case .weatherData:
            return ""
        }
    }
}

private enum WeatherItem: Hashable {
    case currentWeatherData(CurrentWeather)
    case threeHourForecast(WeatherData)
    case fiveDayForecast(DayWeather)
    case mapData(CurrentWeather)
    case weatherData([WeatherDataType: String])
}

final class WeatherViewController: BaseViewController {
    private let viewModel = WeatherViewModel()
    private let cityLabel = BaseLabel(font: .systemFont(ofSize: 32))
    private let tempLabel = BaseLabel(font: .systemFont(ofSize: 70))
    private let descriptionLabel = BaseLabel(font: .systemFont(ofSize: 24))
    private let tempMinMaxLabel = BaseLabel(font: .systemFont(ofSize: 23))
    
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = Color.backgroundColor
        view.showsVerticalScrollIndicator = false
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var bottomToolbar = {
        let view = UIToolbar()
        view.tintColor = .white
        view.barTintColor = Color.backgroundColor
        let mapButton = UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let citySearchButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(citySearchButtonTapped))
        view.setItems([mapButton, flexibleSpace, citySearchButton], animated: true)
        self.view.addSubview(view)
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>!
    private var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backgroundColor
        viewModel.inputViewDidLoadTriggger.value = ()
        configureDataSource()
        bindData()
    }
    
    override func configureLayout() {
        bottomToolbar.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(bottomToolbar.snp.top)
        }
    }
}

// MARK: Compostional Layout
private extension WeatherViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let sectionType = WeatherSection.allCases[sectionIndex]
            switch sectionType {
            case .currentWeather:
                return self?.createCurrentWeatherSection()
            case .threehours:
                let section = self?.createThreeHoursSection()
                section?.boundarySupplementaryItems = [header]
                return section
            case .fivedays:
                let section = self?.createFiveDaysSection()
                section?.boundarySupplementaryItems = [header]
                return section
            case .map:
                return self?.createMapSection()
            case .weatherData:
                return self?.createWeatherDataSection()
            }
        }
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: BackgroundDecorationView.identifier)
        return layout
    }
    
    func createCurrentWeatherSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
    
    func createThreeHoursSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.25 * 1.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.decorationItems = [decorationItem]
        
        return section
    }
    
    func createFiveDaysSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.decorationItems = [decorationItem]
        
        return section
    }
    
    func createMapSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        return section
    }
    
    func createWeatherDataSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0)
        return section
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

// MARK: Data binding
private extension WeatherViewController {
    func bindData() {
        snapshot.appendSections(WeatherSection.allCases)
        viewModel.outputCurrentWeatherData.bind { [weak self] data in
            guard let data, let self else { return }
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .currentWeather))
            snapshot.appendItems([.currentWeatherData(data)], toSection: .currentWeather)
            
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .map))
            snapshot.appendItems([.mapData(data)], toSection: .map)
            
            var weatherDataItems: [WeatherItem] = []
            WeatherDataType.allCases.forEach {
                let value = $0.value(from: data)
                weatherDataItems.append(.weatherData([$0: value]))
            }
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .weatherData))
            snapshot.appendItems(weatherDataItems, toSection: .weatherData)
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputForeCastData.bind { [weak self] data in
            guard let data, let self else { return }
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .threehours))
            snapshot.appendItems(data.list.map { .threeHourForecast($0) }, toSection: .threehours) // [WeatherItem]
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputWeekData.bind { [weak self] data in
            guard let self else { return }
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .fivedays))
            snapshot.appendItems(data.map { .fiveDayForecast($0) }, toSection: .fivedays)
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputErrorMessage.bind { [weak self] message in
            guard let self, let message else { return }
            view.makeToast(message, duration: 3, position: .center)
        }
    }
}

// MARK: Diffable DataSource
private extension WeatherViewController {
    func configureDataSource() {
        let currentWeatherCellRegistration = UICollectionView.CellRegistration<CurrentWeatherCollectionViewCell, CurrentWeather> { cell, indexPath, data in
            cell.configure(data: data)
        }
        
        let threeHoursCellRegistration = UICollectionView.CellRegistration<ThreeHoursCollectionViewCell, WeatherData> { cell, indexPath, data in
            cell.configure(data: data)
        }
        
        let fiveDaysCellRegistration = UICollectionView.CellRegistration<MinMaxTempCollectionViewCell, DayWeather> { cell, indexPath, data in
            cell.configure(data: data, index: indexPath.item)
        }
        
        let mapCellRegistration = UICollectionView.CellRegistration<MapCollectionViewCell, CurrentWeather> { cell, indexPath, data in
            cell.mapView.delegate = self
            cell.configure(data: data)
        }
        
        let weatherCellRegistration = UICollectionView.CellRegistration<WeatherDataCollectionViewCell, [WeatherDataType: String]> { cell, indexPath, data in
            guard let category = WeatherDataType(rawValue: indexPath.item) else { return }
            cell.configure(data: data[category], category: category)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .currentWeatherData(let data):
                return collectionView.dequeueConfiguredReusableCell(using: currentWeatherCellRegistration, for: indexPath, item: data)
            case .threeHourForecast(let data):
                return collectionView.dequeueConfiguredReusableCell(using: threeHoursCellRegistration, for: indexPath, item: data)
            case .fiveDayForecast(let data):
                return collectionView.dequeueConfiguredReusableCell(using: fiveDaysCellRegistration, for: indexPath, item: data)
            case .mapData(let data):
                return collectionView.dequeueConfiguredReusableCell(using: mapCellRegistration, for: indexPath, item: data)
            case .weatherData(let data):
                return collectionView.dequeueConfiguredReusableCell(using: weatherCellRegistration, for: indexPath, item: data)
            }
        })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            var content = UIListContentConfiguration.groupedHeader()
            content.text = section.headerTitle
            content.textProperties.font = .systemFont(ofSize: 18)
            content.textProperties.color = .white
            
            supplementaryView.contentConfiguration = content
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
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
