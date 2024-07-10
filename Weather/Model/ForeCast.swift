//
//  ForeCast.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation

// MARK: - ForeCast
struct ForeCast: Decodable {
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
}

// MARK: - List
struct List: Decodable {
    let dt: Int // UTC
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    
    var time: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let time = date.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).locale(Locale(identifier: "ko_KR")))
        return time
    }
}
