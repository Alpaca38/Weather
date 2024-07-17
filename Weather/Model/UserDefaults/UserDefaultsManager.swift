//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by 조규연 on 7/12/24.
//

import Foundation

final class UserDefaultsManager {
    private init() { }
    static let shared = UserDefaultsManager()
    
    @UserDefault(key: .cityID, defaultValue: 1835847, isCustomObject: false)
    var cityID: Int
    
}
