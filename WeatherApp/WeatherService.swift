//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import CoreLocation
import Alamofire

let kFORECAST_API_KEY = "5978bff4ccea26c30b3b97b0e818e369"
let kFORECAST_API_URL = "https://api.forecast.io/forecast/"

class WeatherService {
    
    /**
     
    
    */
    class func getWeatherDataForCoordinate(coordinate: CLLocationCoordinate2D, completion:(data: String, error: ErrorType?) -> Void) {
        let apiCall = kFORECAST_API_URL + kFORECAST_API_KEY + "/\(coordinate.latitude),\(coordinate.longitude)"
        Alamofire.request(.GET, apiCall)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    completion(data: "test", error: nil)
                }
            }
    }
}
