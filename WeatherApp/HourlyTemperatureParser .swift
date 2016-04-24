//
//  HourlyTemperatureParser .swift
//  WeatherApp
//
//  Created by lola on 4/24/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import Foundation
import SwiftyJSON

class HourlyTemperatureParser {
    
    /**

    */
    class func parseJSON(json: JSON) -> [(Int, Float)] {
        var hourlyData: [(Int, Float)] = []
        for item in json["hourly"]["data"].arrayValue {
            hourlyData.append((item["time"].int!, item["temperature"].float!))
        }
        return hourlyData
    }
}