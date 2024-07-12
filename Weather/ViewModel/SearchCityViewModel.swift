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
    var inputSearch = Observable("")
    
    init() {
        inputViewDidLoadTrigger.bind(false) { [weak self] _ in
            guard let self else { return }
            getCityData()
        }
        
        inputSearch.bind(false) { [weak self] in
            guard let self else { return }
            getSearchCityData($0)
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
    
    func getSearchCityData(_ text: String) {
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
            let filter = cityData.filter {
                $0.name.localizedCaseInsensitiveContains(text)
            }
            outputCityData.value = text.isEmpty ? cityData : filter
        }
    }
}
