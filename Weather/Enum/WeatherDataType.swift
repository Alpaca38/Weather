//
//  WeatherDataType.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import Foundation

enum WeatherDataType: Int, CaseIterable {
    case windSpeed
    case cloud
    case pressure
    case humidity
    
    var title: String {
        switch self {
        case .windSpeed: return "바람 속도"
        case .cloud: return "구름"
        case .pressure: return "기압"
        case .humidity: return "습도"
        }
    }
    
    func value(from weatherData: CurrentWeather) -> String {
        switch self {
        case .windSpeed:
            return "\(weatherData.wind.speed)m/s"
        case .cloud:
            return "\(weatherData.clouds.all)%"
        case .pressure:
            return "\(weatherData.main.pressure)hpa"
        case .humidity:
            return "\(weatherData.main.humidity)%"
        }
    }
}
