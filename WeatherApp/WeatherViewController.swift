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
    var currentGeoCoordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
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
            if (self.currentGeoCoordinate != nil) {
                self.currentGeoCoordinate = nil
            }
            locationManager.startUpdatingLocation()
        }
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (self.currentGeoCoordinate == nil) {
            self.currentGeoCoordinate = manager.location?.coordinate
            manager.stopUpdatingLocation()
            WeatherService.getWeatherDataForCoordinate(self.currentGeoCoordinate, completion: { (data, error) -> Void in
                
            })
        }
    }
}