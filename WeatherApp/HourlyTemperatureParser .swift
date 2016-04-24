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
    class func parseData(json: JSON) -> [(time: Int, temperature: Float)] {
        var hourlyData: [(time: Int, temperature: Float)] = []
        for item in json["hourly"]["data"].arrayValue {
            hourlyData.append((time: item["time"].int!, temperature: item["temperature"].float!))
        }
        return hourlyData
    }
}