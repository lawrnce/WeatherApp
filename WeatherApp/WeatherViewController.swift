//
//  ViewController.swift
//  WeatherApp
//
//  Created by lola on 4/23/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class WeatherViewController: UIViewController {

    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    private var locationManager: CLLocationManager!
    private var hourlyData: OrderedDictionary<String, [(time: String, temperature: String)]>!
    private var shouldCallAPI: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupTableView()
        self.shouldCallAPI = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCurrentLocation()
        
        let testJSON = JSON(["hourly": ["data": [ ["temperature": 17.82, "time": 1461484800], ["temperature": 16.54, "time": 1461488400], ["temperature": 15.8, "time": 1461492000]]]])
        
        print(HourlyTemperatureParser.parseJSON(testJSON))
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
        self.hourlyTableView.registerNib(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: kHOURLY_TABLEVIEW_CELL_REUSE_IDENTIFIER)
        self.hourlyTableView.allowsSelection = false
    }
    
    // MARK: - Actions
    
    /**
        Begins the location manager.
    */
    func getCurrentLocation() {
        if (CLLocationManager.locationServicesEnabled() == true) {
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
    }
}

// MARK: - Table View Data Source 
extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard self.hourlyData != nil else {
            return 0
        }
        // Display today and tomorrow for demo
        return self.hourlyData.keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.hourlyData != nil else {
            return 0
        }
        let key = self.hourlyData.keys[section]
        return (self.hourlyData[key]?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kHOURLY_TABLEVIEW_CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! HourlyTableViewCell
        let key = self.hourlyData.keys[indexPath.section]
        cell.timeLabel.text = self.hourlyData[key]![indexPath.row].time
        cell.temperatureLabel.text = self.hourlyData[key]![indexPath.row].temperature
        return UITableViewCell()
    }
}

// MARK: - Table View Delegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.hourlyData.keys[section]
    }
}

// MARK: - Location Manager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Stop location manager after we get the location once.
        manager.stopUpdatingLocation()
        
        // location manager does not stop immediately, so use a bool to check if we should call the api.
        if (self.shouldCallAPI == true) {
            self.shouldCallAPI = false
            
            // Call the forecast api
            WeatherService.getWeatherDataForCoordinate((manager.location?.coordinate)!, completion: { (json, error) -> Void in
                
                // Success
                if (error == nil) {
                    
                    // Check if data already exists
                    if (self.hourlyData == nil) {
                        
                        // Parse the data and reload table view
                        self.hourlyData = HourlyTemperatureParser.parseJSON(json!)
                        self.hourlyTableView.reloadData()
                    }

                // Error
                } else {
                    
                }
            })
        }
    }
}