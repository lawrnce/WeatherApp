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
        Parses raw JSON data from Forecast.io into format readable to the table view model.
     
        - Parameter json: JSON data from a Forecast.io call.
        - Returns: An ordered dictionary with key as the day and value as an array of times and temperature. 
    */
    class func parseJSON(json: JSON) -> OrderedDictionary<String, [(time: String, temperature: String)]> {
        
        var hourlyData = OrderedDictionary<String, [(time: String, temperature: String)]>()
        var currentDay: String!
        
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "EEEE"
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "h a"
        
        // Read data from JSON
        for item in json["hourly"]["data"].arrayValue {
            
            // cast timestamp to readable date
            let date = NSDate(timeIntervalSince1970: item["time"].double!)
            
            // cast day
            let dayString = dayFormatter.stringFromDate(date)
            
            // cast time
            let timeString = timeFormatter.stringFromDate(date)
            
            // cast temperature
            let tempString = String(item["temperature"].float!) + " \u{00B0}C"
 
            // set first day and check if new day
            if (currentDay == nil || currentDay != dayString) {
                currentDay = dayString
                hourlyData[currentDay] = [(time: String, temperature: String)]()
            }
            
            // append new time and temperature
            hourlyData[currentDay]?.append((time: timeString, temperature: tempString))
        }
        
        return hourlyData
    }
}







