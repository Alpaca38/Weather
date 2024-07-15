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

extension CityList {
    static func getCityData() -> CityList {
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json") else {
            return []
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return []
        }

        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        guard let data, let cityData = try? decoder.decode(CityList.self, from: data) else { return [] }
        
        return cityData
    }
    
    static func getSearchCityData(_ text: String) -> CityList {
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json") else {
            return []
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return []
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        guard let data, let cityData = try? decoder.decode(CityList.self, from: data) else { return [] }
        let filter = cityData.filter {
            $0.name.localizedCaseInsensitiveContains(text)
        }
        return text.isEmpty ? cityData : filter
    }
}
