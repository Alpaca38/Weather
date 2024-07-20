//
//  ForeCast.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation

// MARK: - ForeCast
struct ForeCast: Decodable, Hashable {
    let list: [WeatherData]
    let city: City
}

// MARK: - City
struct City: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let coord: Coord
}

// MARK: - List
struct WeatherData: Decodable, Hashable {
    let dt: Int // UTC
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let dt_txt: String
    
    var time: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let time = date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).locale(Locale(identifier: "ko_KR")))
        return time
    }
    
    var day: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let day = Calendar.current.startOfDay(for: date).formatted(.dateTime.day().locale(Locale(identifier: "ko_KR")))
        return day
    }
}
