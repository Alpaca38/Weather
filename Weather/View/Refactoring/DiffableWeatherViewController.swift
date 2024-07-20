//
//  DiffableWeatherViewController.swift
//  Weather
//
//  Created by 조규연 on 7/20/24.
//

import UIKit
import MapKit
import SnapKit

private enum WeatherSection: Int, CaseIterable {
    case threehours
    case fivedays
    case map
    case weatherData
    
    var headerTitle: String {
        switch self {
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
    case threeHourForecast(WeatherData)
    case fiveDayForecast(DayWeather)
    case mapData(CurrentWeather)
    case weatherData([WeatherDataType: String])
}

final class DiffableWeatherViewController: BaseViewController {
    private let viewModel = WeatherViewModel()
    private lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = Color.backgroundColor
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private var dataSource: UICollectionViewDiffableDataSource<WeatherSection, WeatherItem>!
    private var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backgroundColor
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = Color.backgroundColor
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        
        viewModel.inputViewDidLoadTriggger.value = ()
        configureDataSource()
        bindData()
    }
    
    override func configureLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: Data Binding
private extension DiffableWeatherViewController {
    func bindData() {
        snapshot.appendSections(WeatherSection.allCases)
        viewModel.outputCurrentWeatherData.bind { [weak self] data in
            guard let data, let self else { return }
            snapshot.appendItems([.mapData(data)], toSection: .map)
            
            var weatherDataItems: [WeatherItem] = []
            WeatherDataType.allCases.forEach {
                let value = $0.value(from: data)
                weatherDataItems.append(.weatherData([$0: value]))
            }
            snapshot.appendItems(weatherDataItems, toSection: .weatherData)
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputForeCastData.bind { [weak self] data in
            guard let data, let self else { return }
            snapshot.appendItems(data.list.map { .threeHourForecast($0) }, toSection: .threehours) // [WeatherItem]
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputWeekData.bind { [weak self] data in
            guard let self else { return }
            snapshot.appendItems(data.map { .fiveDayForecast($0) }, toSection: .fivedays)
            
            dataSource.apply(snapshot)
        }
        
        viewModel.outputErrorMessage.bind { [weak self] message in
            guard let self, let message else { return }
            view.makeToast(message, duration: 3, position: .center)
        }
    }
}

// MARK: Compositional Layout
private extension DiffableWeatherViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment -> NSCollectionLayoutSection? in
            let sectionType = WeatherSection.allCases[sectionIndex]
            switch sectionType {
            case .threehours:
                return self?.createThreeHoursSection()
            case .fivedays:
                return self?.createFiveDaysSection()
            case .map:
                return self?.createMapSection()
            case .weatherData:
                return self?.createWeatherDataSection()
            }
        }
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: BackgroundDecorationView.identifier)
        return layout
    }
    
    func createThreeHoursSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.25 * 1.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: BackgroundDecorationView.identifier)
        decorationItem.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
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
}

// MARK: Diffable DataSource
private extension DiffableWeatherViewController {
    func configureDataSource() {
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
    }
}

extension DiffableWeatherViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKAnnotationView.identifier)
        guard let humidity = viewModel.outputCurrentWeatherData.value?.main.humidity else { return MKAnnotationView() }
        annotationView.glyphText = "\(humidity)"
        return annotationView
    }
}
