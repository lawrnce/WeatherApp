//
//  ReverseGeoCoder.swift
//  WeatherApp
//
//  Created by lola on 4/24/16.
//  Copyright © 2016 LawrenceTran. All rights reserved.
//

import Foundation
import CoreLocation

class ReverseGeocoder: NSObject {
    
    var geocoder: CLGeocoder!
    
    override init() {
        super.init()
        self.geocoder = CLGeocoder()
    }
    
    /**
        Determines the area name for a geo coordinate.
     
        - Parameter coordinate: The location to be determined.
        - Parameter completion: The block to execute after reverse geocoding. This block returns a string or an error.
    */
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion:(name: String?, error: ErrorType?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if (error == nil && (placemarks! as [CLPlacemark]).count > 0) {
                let placemark = (placemarks! as [CLPlacemark]).last
                completion(name: placemark?.locality, error: nil)
            } else {
                completion(name: nil, error: error)
            }
        }
    }
}