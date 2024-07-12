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
    var outputErrorMessage: Observable<String?> = Observable(nil)
    
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
        let now = Date()
        let groupedData = Dictionary(grouping: data.list) { (weatherData) -> String in
            let date = Date(timeIntervalSince1970: TimeInterval(weatherData.dt))
            let day = Calendar.current.startOfDay(for: date).formatted(.dateTime.weekday(.abbreviated).locale(Locale(identifier: "ko_KR")))
            return day
        }
        
        let dayWeathers = groupedData.compactMap { (day, items) -> DayWeather? in
            guard let closestItem = items.min(by: {
                Double($0.dt) - now.timeIntervalSince1970 < Double($1.dt) - now.timeIntervalSince1970
            }) else {
                return nil
            }
            let weatherIconURL = closestItem.weather.first?.imageURL
            let minTemp = items.map { $0.main.tempMin }.min() ?? 0.0
            let maxTemp = items.map { $0.main.tempMax }.max() ?? 0.0
            return DayWeather(day: day, weatherIconURL: weatherIconURL, tempMin: minTemp, tempMax: maxTemp, dt: closestItem.dt)
        }
        
        return dayWeathers.sorted { $0.dt < $1.dt }
    }
    
    private func requestForeCastWithId(id: Int) {
        NetworkManager.shared.getWeatherData(api: .forecast(parameter: .cityID(id: id)), responseType: ForeCast.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputForeCastData.value = success
                outputWeekData.value = getFiveDaysWeather(data: success)
            case .failure(let failure):
                outputErrorMessage.value = failure.rawValue
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
                outputErrorMessage.value = failure.rawValue
            }
        }
    }
}
