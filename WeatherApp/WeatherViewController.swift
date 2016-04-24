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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alertImageView: UIImageView!
    
    private var locationManager: CLLocationManager!
    private var hourlyData: OrderedDictionary<String, [(time: String, temperature: String)]>!
    private var shouldCallAPI: Bool!
    private var reverseGeocoder: ReverseGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupTableView()
        self.shouldCallAPI = true
        self.reverseGeocoder = ReverseGeocoder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.alertImageView.hidden = true
        updateCurrentLocation()
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
        self.hourlyTableView.hidden = true
    }
    
    // MARK: -- Methods
    
    /**
        Begins the location manager.
     */
    func updateCurrentLocation() {
        if (CLLocationManager.locationServicesEnabled() == true) {
            if (CLLocationManager.authorizationStatus() == .Denied) {
                self.alertImageView.image = UIImage(named: "EnableLocationServices")
                self.alertImageView.hidden = false
            } else {
                self.activityIndicator.startAnimating()
                self.locationManager.startUpdatingLocation()
                self.alertImageView.hidden = true
                self.hourlyTableView.hidden = true
            }
        }
    }
    
    /**
        Get location name.
     */
    func updateLocationNameForCoordinate(coordinate: CLLocationCoordinate2D) {
        self.reverseGeocoder.reverseGeocode(coordinate) { (name, error) -> Void in
            if (error == nil) {
                self.topBar.topItem?.title = name!
            } else {
                self.topBar.topItem?.title = ""
            }
        }
    }
     
    /**
        Refresh data.
     */
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        self.shouldCallAPI = true
        self.hourlyData = nil
        updateCurrentLocation()
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
                        self.hourlyTableView.hidden = false
                        self.alertImageView.hidden = true
                    }

                // Error
                } else {
                    self.alertImageView.image = UIImage(named: "NetworkError")
                    self.alertImageView.hidden = false
                }
                
                self.activityIndicator.stopAnimating()
            })
            
            // Reverse Geocode name
            updateLocationNameForCoordinate((manager.location?.coordinate)!)
        }
    }
}