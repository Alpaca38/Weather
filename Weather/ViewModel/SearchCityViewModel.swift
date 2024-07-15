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
            outputCityData.value = CityList.getCityData()
        }
        
        inputSearch.bind(false) { [weak self] in
            guard let self else { return }
            outputCityData.value = CityList.getSearchCityData($0)
        }
    }
}
