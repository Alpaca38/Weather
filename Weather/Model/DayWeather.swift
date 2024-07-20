//
//  DayWeather.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import Foundation

struct DayWeather: Hashable {
    let day: String
    let weatherIconURL: URL?
    let tempMin: Double
    let tempMax: Double
    let dt: Int
    
    var tempMinString: String {
        let convertedMin = (tempMin - 273.15).formatted(.number.precision(.fractionLength(1)))
        return "최저 \(convertedMin)º"
    }
    
    var tempMaxString: String {
        let convertedMax = (tempMax - 273.15).formatted(.number.precision(.fractionLength(1)))
        return "최고 \(convertedMax)º"
    }
}

typealias DayWeatherList = [DayWeather]

extension DayWeatherList {
    func getFiveDaysWeather(data: ForeCast) -> DayWeatherList {
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
}
