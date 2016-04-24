//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import XCTest
import CoreLocation
import SwiftyJSON

@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var weatherVC: WeatherViewController!
    
    override func setUp() {
        super.setUp()
        self.weatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! WeatherViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetWeatherDataFromApiEndpoint() {
        let expectation = expectationWithDescription("GET Weather Data")
        let testCoordinate = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        WeatherService.getWeatherDataForCoordinate(testCoordinate) { (data, error) -> Void in
            if (error == nil) {
               expectation.fulfill()
            }
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testParseDataToTupleArray() {
        let testJSON = JSON(["hourly": ["data": [ ["temperature": 17.82, "time": 1461484800], ["temperature": 16.54, "time": 1461488400], ["temperature": 15.8, "time": 1461492000]]]])
        let expectedTupleArray:[(Int, Float)] = [(1461484800, 17.82), (1461488400, 16.54), (1461492000, 15.8)]
        let result = HourlyTemperatureParser.parseJSON(testJSON)
        XCTAssertEqual("\(expectedTupleArray)", "\(result)", "Expected parse tuple failed.")
    }
}
