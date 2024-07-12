//
//  MapViewController.swift
//  Weather
//
//  Created by 조규연 on 7/12/24.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

final class MapViewController: BaseViewController {
    private lazy var mapView = {
        let view = MKMapView()
        self.view.addSubview(view)
        return view
    }()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        configureMapView()
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension MapViewController {
    func configureMapView() {
        let center = CLLocationCoordinate2D(latitude: 37.517635, longitude: 126.886412)
        mapView.region = MKCoordinateRegion(
            center: center, latitudinalMeters: 500, longitudinalMeters: 500
        )
    }
    
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.currentLocationAuthorization()
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "아이폰 위치 서비스를 활성화해야합니다.", message: "설정 - 개인정보 보호 및 보안 - 위치 서비스를 활성화 해주세요. 설정으로 이동하시겠습니까?", buttonTitle: "설정으로 이동") {
                        if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingURL)
                        }
                    }
                }
            }
        }
    }
    
    func currentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            DispatchQueue.main.async {
                self.showAlert(title: "앱의 위치 권한을 설정해주세요.", message: "설정 - 개인정보 보호 및 보안 - 위치 서비스에서 앱의 위치 권한을 설정해주세요. 설정으로 이동하시겠습니까?", buttonTitle: "설정으로 이동") {
                    if let settingURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingURL)
                    }
                }
            }
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        view.makeToast(error.localizedDescription, duration: 3, position: .center)
        print(error.localizedDescription)
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
}
