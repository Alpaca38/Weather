//
//  WeatherResponse.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation

// MARK: - WeatherResponse
struct CurrentWeather: Decodable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let name: String
    let wind: Wind
    let clouds: Clouds
}

// MARK: - Clouds
struct Clouds: Decodable {
    let all: Int
}

// MARK: - Coord
struct Coord: Decodable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Decodable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    var tempString: String {
        let convertedTemp = (temp - 273.15).formatted(.number.precision(.fractionLength(1)))
        return "\(convertedTemp)º"
    }
    
    var tempMinMaxString: String {
        let convertedMax = (tempMax - 273.15).formatted(.number.precision(.fractionLength(1)))
        let convertedMin = (tempMin - 273.15).formatted(.number.precision(.fractionLength(1)))
        return "최고 : \(convertedMax)º | 최저 : \(convertedMin)º"
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Rain
struct Rain: Decodable {
    let oneHour: Double
    let threeHours: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Snow: Decodable {
    let oneHour: Double
    let threeHours: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

// MARK: - Sys
struct Sys: Decodable {
    
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
    
    var imageURL: URL? {
        let url = URL(string: "https://openweathermap.org/img/wn/\(icon).png")
        return url
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
}
