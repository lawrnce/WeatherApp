//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import CoreLocation
import Alamofire
import SwiftyJSON

let kFORECAST_API_KEY = "5978bff4ccea26c30b3b97b0e818e369"
let kFORECAST_API_URL = "https://api.forecast.io/forecast/"

class WeatherService {
    
    /**
     
    
    */
    class func getWeatherDataForCoordinate(coordinate: CLLocationCoordinate2D, completion:(json: JSON?, error: ErrorType?) -> Void) {
        
        let apiCall = kFORECAST_API_URL + kFORECAST_API_KEY + "/\(coordinate.latitude),\(coordinate.longitude)"
        
        Alamofire.request(.GET, apiCall, parameters: ["units": "si", "exclude": "currently,minutely,daily,alerts,flags"])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    completion(json: JSON(data: response.data!), error: nil)
                case .Failure(let error):
                    completion(json: nil, error: error)
                }
            }
    }
}
