//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import XCTest
import CoreLocation
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
    
    func testGET_WEATHER_DATA_FROM_API_ENDPOINT() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        self.weatherVC.getWeatherDataForCoordinate(testCoordinate)
    }
}
