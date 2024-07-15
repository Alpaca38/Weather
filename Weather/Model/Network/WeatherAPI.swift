//
//  WeatherAPI.swift
//  Weather
//
//  Created by 조규연 on 7/10/24.
//

import Foundation
import Alamofire

enum WeatherAPI {
    case current(parameter: Parameter)
    case forecast(parameter: Parameter)
    
    enum Parameter {
        case cityID(id: Int)
        case coordinates(lat: Double, lon: Double)
    }
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endpoint: URL? {
        switch self {
        case .current:
            return URL(string: baseURL + "weather")
        case .forecast:
            return URL(string: baseURL + "forecast")
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .current(let parameter), .forecast(let parameter):
            switch parameter {
            case .cityID(let id):
                ["id": id, "appid": APIKey.openWeahterAPIKey]
            case .coordinates(let lat, let lon):
                ["lat": lat, "lon": lon, "appid": APIKey.openWeahterAPIKey]
            }
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
