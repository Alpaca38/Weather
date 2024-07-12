//
//  SearchCityViewModel.swift
//  Weather
//
//  Created by 조규연 on 7/11/24.
//

import Foundation

final class SearchCityViewModel {
    var outputCityData: Observable<CityList> = Observable([])
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        inputViewDidLoadTrigger.bind(false) { [weak self] _ in
            guard let self else { return }
            getCityData()
        }
    }
    
    func getCityData() {
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json") else {
            return
        }
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }

        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        if let data = data,
           let cityData = try? decoder.decode(CityList.self, from: data) {
            outputCityData.value = cityData
        }
    }
}
