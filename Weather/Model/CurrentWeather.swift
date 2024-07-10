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
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds
    let dt: Int // UTC
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
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
        return "\(temp)º"
    }
    
    var tempMinMaxString: String {
        return "최고 : \(tempMax)º | 최저 : \(tempMin)º"
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
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double
}
