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

    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    var locationManager: CLLocationManager!
    var hourlyData: OrderedDictionary<String, [(time: String, temperature: Float)]>!
    var shouldCallAPI: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupTableView()
        self.shouldCallAPI = true
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
        self.hourlyTableView.registerNib(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: kHOURLY_TABLEVIEW_CELL_REUSE_IDENTIFIER)
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
}

// MARK: - Table View Data Source 
extension WeatherViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard self.hourlyData != nil else {
            return 0
        }
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
        let time = self.hourlyData[key]![indexPath.row].time
        cell.timeLabel.text = time
        return UITableViewCell()
    }
}

// MARK: - Table View Delegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let key = self.hourlyData.keys[section]
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        sectionLabel.text = key
        sectionLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        sectionLabel.backgroundColor = UIColor.whiteColor()
        sectionLabel.textAlignment = .Center
        return sectionLabel
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
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