//
//  MapCollectionViewCell.swift
//  Weather
//
//  Created by 조규연 on 7/20/24.
//

import UIKit
import MapKit
import SnapKit

final class MapCollectionViewCell: BaseCollectionViewCell {
    lazy var mapView = {
        let view = MKMapView()
        contentView.addSubview(view)
        return view
    }()
    
    override func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
