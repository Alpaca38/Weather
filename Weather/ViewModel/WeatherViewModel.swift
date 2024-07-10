//
//  WeatherViewModel.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation
import Alamofire

final class WeatherViewModel {
    var outputCurrentWeatherData: Observable<CurrentWeather?> = Observable(nil)
    var outputForeCastData: Observable<ForeCast?> = Observable(nil)
    
    var inputViewDidLoadTriggger: Observable<Void?> = Observable(nil)
    var inputCityID: Observable<Int> = Observable(1835847)
    
    init() {
        inputViewDidLoadTriggger.bind(false) { [weak self] _ in
            guard let self else { return }
            requestCurrentWeatherWithID(id: inputCityID.value)
            requestForeCastWithId(id: inputCityID.value)
        }
        
        inputCityID.bind(false) { [weak self] value in
            guard let self else { return }
            requestCurrentWeatherWithID(id: value)
            requestForeCastWithId(id: value)
        }
    }
    
    private func requestForeCastWithId(id: Int) {
        NetworkManager.shared.getWeatherData(api: .forecast(parameter: .cityID(id: id)), responseType: ForeCast.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputForeCastData.value = success
            case .failure(let failure):
                switch failure {
                case .invalidRequestVariables:
                    print(failure.rawValue)
                case .invalidURL:
                    print(failure.rawValue)
                case .failedAuthentication:
                    print(failure.rawValue)
                case .invalidReauest:
                    print(failure.rawValue)
                case .invalidMethod:
                    print(failure.rawValue)
                case .requestLimit:
                    print(failure.rawValue)
                case .serverError:
                    print(failure.rawValue)
                case .networkDelay:
                    print(failure.rawValue)
                case .failedRequest:
                    print(failure.rawValue)
                case .invalidResponse:
                    print(failure.rawValue)
                case .noData:
                    print(failure.rawValue)
                case .invalidData:
                    print(failure.rawValue)
                }
            }
        }
    }
    
    private func requestCurrentWeatherWithID(id: Int) {
        NetworkManager.shared.getWeatherData(api: .current(parameter: .cityID(id: id)), responseType: CurrentWeather.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputCurrentWeatherData.value = success
            case .failure(let failure):
                switch failure {
                case .invalidRequestVariables:
                    print(failure.rawValue)
                case .invalidURL:
                    print(failure.rawValue)
                case .failedAuthentication:
                    print(failure.rawValue)
                case .invalidReauest:
                    print(failure.rawValue)
                case .invalidMethod:
                    print(failure.rawValue)
                case .requestLimit:
                    print(failure.rawValue)
                case .serverError:
                    print(failure.rawValue)
                case .networkDelay:
                    print(failure.rawValue)
                case .failedRequest:
                    print(failure.rawValue)
                case .invalidResponse:
                    print(failure.rawValue)
                case .noData:
                    print(failure.rawValue)
                case .invalidData:
                    print(failure.rawValue)
                }
            }
        }
    }
}
