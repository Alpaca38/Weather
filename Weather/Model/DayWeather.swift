//
//  DayWeather.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import Foundation

struct DayWeather {
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
