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
    var hourlyData: [(Int, Float)]!
    var temperatureTableView: UITableView!
    
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
    
    // MARK: - Setup
    
    /**
        Setups the location manager.
    */
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    /**
        Setups the table view.
    */
    private func setupTableView() {
        
    }
    
    // MARK: - Action
    
    /**
        Begins the location manager.
    */
    func getCurrentLocation() {
        if (CLLocationManager.locationServicesEnabled() == true) {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Table View Data Source 
extension WeatherViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hourlyData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - Location Manager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Stop location manager after we get the location once.
        manager.stopUpdatingLocation()
        
        // Call the forecast api
        WeatherService.getWeatherDataForCoordinate((manager.location?.coordinate)!, completion: { (json, error) -> Void in
            
            // Success
            if (error == nil) {
                
                // Parse the data and reload table view
                self.hourlyData = HourlyTemperatureParser.parseJSON(json!)
                self.temperatureTableView.reloadData()
            
            // Error
            } else {
               
            }
        })
    }
}