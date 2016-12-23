//
//  UserLocationManager.swift
//  Dripdoctors
//
//  Created by mac on 8/9/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class UserLocationManager: NSObject,CLLocationManagerDelegate {
    static let sharedManager = UserLocationManager()
    var city = "new york"
    var state = ""
    var postalCode = ""
    var region: CLPlacemark?
    var regions = false
    var longitude : Double?
    var latitude : Double?
    
    let geocoder = CLGeocoder()
    let locale = NSLocale.currentLocale()
    var locationManager: CLLocationManager!
    var status: CLAuthorizationStatus = .NotDetermined
    
    var currentLocation: CLLocation! {
        didSet {
            if !regions {
                regions = true
                defineCurrentRegion()
            }
        }
    }
    func defineCurrentRegion() {
        if currentLocation != nil {
            self.longitude = currentLocation.coordinate.longitude
            self.latitude = currentLocation.coordinate.latitude
            geocoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
                if placemarks != nil {
                    self.region = placemarks?.first
                    self.city = self.region!.locality!
                    self.state = self.region!.administrativeArea!
//                    self.postalCode = self.region!.postalCode!
                }
            }
        }
        
    }
    func startManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.activityType = .Fitness
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.allowsBackgroundLocationUpdates = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        if currentLocation == nil {
            currentLocation = newLocation
        }
        
        if newLocation.verticalAccuracy < 0 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        let locationAge: NSTimeInterval = -newLocation.timestamp.timeIntervalSinceNow
        if locationAge > 5.0 {
            return
        }
        
        if newLocation.horizontalAccuracy <= 10 {
            currentLocation = newLocation
        }
    }
    func mapRectForBounds(sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) -> MKMapRect {
        
        let pointNE = MKMapPointForCoordinate(ne)
        let pointSW = MKMapPointForCoordinate(sw)
        let antimeridianOveflow = (ne.longitude > sw.longitude) ? 0 : MKMapSizeWorld.width
        return MKMapRectMake(pointSW.x, pointNE.y, (pointNE.x - pointSW.x) + antimeridianOveflow, (pointSW.y - pointNE.y))
    }
    
    func returnDistance(lat: Double, lng: Double) -> Double {
        let poi = CLLocation(latitude: lat, longitude: lng)
        return currentLocation.distanceFromLocation(poi) * 0.00062137
    }
}
