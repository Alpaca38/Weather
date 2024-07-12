//
//  MapTableViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import UIKit
import MapKit
import SnapKit

final class MapTableViewCell: BaseTableViewCell {
    private let titleLabel = {
        let view = BaseLabel(font: .systemFont(ofSize: 18))
        view.text = "습도"
        return view
    }()
    
    lazy var mapView = {
        let view = MKMapView()
        return view
    }()
    
    private lazy var customView = {
        let view = UIView()
        view.backgroundColor = Color.contentBackgroundColor
        view.layer.cornerRadius = 10
        view.addSubview(titleLabel)
        view.addSubview(mapView)
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
    }
    
    func configure(data: CurrentWeather?) {
        guard let data else { return }
        mapView.setCenter(CLLocationCoordinate2D(latitude: data.coord.lat, longitude: data.coord.lon), animated: true)
        
        createAnnotation(data: data)
    }
    
    private func createAnnotation(data: CurrentWeather) {
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: data.coord.lat , longitude: data.coord.lon)
        mapView.addAnnotation(annotation)
    }
}
