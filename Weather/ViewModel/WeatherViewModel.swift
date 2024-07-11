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
    var outputWeekData: Observable<[DayWeather]> = Observable([])
    
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
    
    private func getFiveDaysWeather(data: ForeCast) -> [DayWeather] {
        var list: [DayWeather] = []
        let now = Date()
        var groupedData: [String: [WeatherData]] = [:]
        data.list.forEach {
            let date = Date(timeIntervalSince1970: TimeInterval($0.dt))
            let day = Calendar.current.startOfDay(for: date).formatted(.dateTime.weekday(.abbreviated).locale(Locale(identifier: "ko_KR")))
            
            if groupedData[day] == nil {
                groupedData[day] = []
            }
            groupedData[day]?.append($0)
        }
        groupedData.forEach {
            if let closestItem = $0.value.min(by: { Double($0.dt) - Date().timeIntervalSince1970 < Double($1.dt) - Date().timeIntervalSince1970 }) {
                let dayWeather = DayWeather(day: $0.key, weatherIconURL: closestItem.weather.first?.imageURL, tempMin: closestItem.main.tempMin, tempMax: closestItem.main.tempMax, dt: closestItem.dt)
                list.append(dayWeather)
            }
        }
        return list.sorted { $0.dt < $1.dt }
    }
    
    private func requestForeCastWithId(id: Int) {
        NetworkManager.shared.getWeatherData(api: .forecast(parameter: .cityID(id: id)), responseType: ForeCast.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputForeCastData.value = success
                outputWeekData.value = getFiveDaysWeather(data: success)
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
