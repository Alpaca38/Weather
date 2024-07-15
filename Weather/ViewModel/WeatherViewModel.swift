//
//  WeatherViewModel.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation

final class WeatherViewModel {
    var outputCurrentWeatherData: Observable<CurrentWeather?> = Observable(nil)
    var outputForeCastData: Observable<ForeCast?> = Observable(nil)
    var outputWeekData: Observable<[DayWeather]> = Observable([])
    var outputErrorMessage: Observable<String?> = Observable(nil)
    
    var inputViewDidLoadTriggger: Observable<Void?> = Observable(nil)
    var inputCityID: Observable<Int> = Observable(UserDefaultsManager.shared.cityID)
    var inputCityCoord: Observable<Coord?> = Observable(nil)
    
    init() {
        inputViewDidLoadTriggger.bind(false) { [weak self] _ in
            guard let self else { return }
            requestCurrentWeatherWithID(id: inputCityID.value)
            requestForeCastWithId(id: inputCityID.value)
        }
        
        inputCityID.bind(false) { [weak self] id in
            guard let self else { return }
            UserDefaultsManager.shared.cityID = id
            requestCurrentWeatherWithID(id: id)
            requestForeCastWithId(id: id)
        }
        
        inputCityCoord.bind(false) { [weak self] coord in
            guard let self , let coord else { return }
            requestCurrentWeatherWithCoord(coord: coord)
            requestForeCastWithCoord(coord: coord)
        }
    }
    
    private func requestForeCastWithId(id: Int) {
        NetworkManager.shared.getWeatherData(api: .forecast(parameter: .cityID(id: id)), responseType: ForeCast.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputForeCastData.value = success
                outputWeekData.value = DayWeatherList.getFiveDaysWeather(data: success)
            case .failure(let failure):
                outputErrorMessage.value = failure.rawValue
            }
        }
    }
    
    private func requestForeCastWithCoord(coord: Coord) {
        NetworkManager.shared.getWeatherData(api: .forecast(parameter: .coordinates(lat: coord.lat, lon: coord.lon)), responseType: ForeCast.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                outputForeCastData.value = success
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
    
    private func requestCurrentWeatherWithCoord(coord: Coord) {
        NetworkManager.shared.getWeatherData(api: .current(parameter: .coordinates(lat: coord.lat, lon: coord.lon)), responseType: CurrentWeather.self) { [weak self] result in
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
