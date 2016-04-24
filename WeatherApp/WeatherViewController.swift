//
//  ViewController.swift
//  WeatherApp
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    var locationManager: CLLocationManager!
    var hourlyData: [(time: Int, temperature: Float)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() {
        if (CLLocationManager.locationServicesEnabled() == true) {
            locationManager.startUpdatingLocation()
        }
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
        manager.stopUpdatingLocation()
        WeatherService.getWeatherDataForCoordinate((manager.location?.coordinate)!, completion: { (data, error) -> Void in
            if (error == nil) {
                self.hourlyData = HourlyTemperatureParser.parseData(data!)
                print(self.hourlyData)
            } else {
                print(error)
            }
        })
    }
}