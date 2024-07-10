//
//  ForeCast.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation

// MARK: - ForeCast
struct ForeCast: Decodable {
    let cod: String
    let message, cnt: Int
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
    let rain: Rain?
    let snow: Snow?
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, rain, snow
        case dtTxt = "dt_txt"
    }
}
