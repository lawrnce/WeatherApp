//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

let kFORECAST_API_KEY = "5978bff4ccea26c30b3b97b0e818e369"
let kFORECAST_API_URL = "https://api.forecast.io/forecast/"

class WeatherService: NSObject {
    func getWeatherDataForCoordinate(coordinate: CLLocationCoordinate2D, completion:(data: String) -> Void) {
        
    }
}
