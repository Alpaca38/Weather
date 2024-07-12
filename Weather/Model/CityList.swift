//
//  CityList.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import Foundation

struct CityListElement: Decodable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Coord
}

typealias CityList = [CityListElement]
