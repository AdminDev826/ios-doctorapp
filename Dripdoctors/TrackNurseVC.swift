//
//  TrackNurseVC.swift
//  Dripdoctors
//
//  Created by mac on 8/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import MapKit

class TrackNurseVC: UIViewController {
    @IBOutlet weak var vwMap: MKMapView!
    
    @IBOutlet weak var vwNurseInfo: UIView!
    @IBOutlet weak var imgNursePhoto: UIImageView!
    @IBOutlet weak var imgReview1: UIImageView!
    @IBOutlet weak var imgReview2: UIImageView!
    @IBOutlet weak var imgReview3: UIImageView!
    @IBOutlet weak var imgReview4: UIImageView!
    @IBOutlet weak var imgReview5: UIImageView!
    @IBOutlet weak var lblNurseOverview: UILabel!
    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var lblNurseAddress: UILabel!
    @IBOutlet weak var scAvServices: UIScrollView!
    
    let apiManager = APIManager.sharedManager
    let locationManager = UserLocationManager.sharedManager
    var nurseInfo : Nurse?
    var userLongitude : Double?
    var userLatitude : Double?
    var centerPoint: CLLocationCoordinate2D?
    let imgPin = UIImage(named: "pin_normal")
    let imgSelectedPin = UIImage(named: "pin2")
    var nurseImage : UIImage?
    
    var lastNurseCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 36.000, longitude: 117)
    var userCoordinate : CLLocationCoordinate2D?
    var apiTimer = NSTimer()
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TrackNurseVC.loadPinsOnMap), name: "NurseInformationLoaded", object: nil)
        setup()
        updateMapView()
        if Singleton.sharedInstance.currentClientSelectedBookingItem != nil {
            self.nurseInfo = Singleton.sharedInstance.currentClientSelectedBookingItem?.nurseInfo
            if let img_Url = self.nurseInfo!.imgUrl {
                let url = NSURL(string: img_Url)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        self.nurseImage = image
                        NSNotificationCenter.defaultCenter().postNotificationName("NurseInformationLoaded", object: nil)
//                        self.startTimer()
                    }
                    
                }).resume()
            }
        }
        apiTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(TrackNurseVC.updateNurseLocation(_:)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    func loadPinsOnMap() {
        print("finished.")
//        self.startTimer()
    }
    func setup() {
        if locationManager.longitude != nil {
            self.userLongitude = locationManager.longitude!
        } else {
            self.userLongitude = -118.000
        }
        if locationManager.latitude != nil {
            self.userLatitude = locationManager.latitude!
        } else {
            self.userLatitude = 34.000
        }
        userCoordinate = CLLocationCoordinate2D(latitude: self.userLatitude!, longitude: self.userLongitude!)
    }
    func updateMapView() {
        vwMap.delegate = self
        centerPoint = CLLocationCoordinate2D(latitude: self.userLatitude!, longitude: self.userLongitude!)
        vwMap.showsUserLocation = true
//        let distance = self.determineDistance(centerPoint, locationTwo: <#T##CLLocationCoordinate2D#>)
        let region = MKCoordinateRegionMake(centerPoint!, MKCoordinateSpanMake(0.1, 0.1))
        print("region = \(region)")
        vwMap.setRegion(region, animated: true)
    }
    func determineDistance(locationOne: CLLocationCoordinate2D, locationTwo: CLLocationCoordinate2D) -> Double {
        let center = CLLocation(latitude: locationOne.latitude, longitude: locationOne.longitude)
        let edge = CLLocation(latitude: locationTwo.latitude, longitude: locationTwo.longitude)
        return center.distanceFromLocation(edge) * 0.000621371192
    }
    func setupAnnotation(long: Double, lat: Double) {
        
    }
    func startTimer() {
        NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(TrackNurseVC.updateNurseLocation(_:)), userInfo: nil, repeats: true)
    }
    func updateNurseLocation(timer : NSTimer) {
        print("log");
        count += 1
        var nurseId = ""
        if Singleton.sharedInstance.currentClientSelectedBookingItem?.nurseIdAssigned == false {
            nurseId = "1"
        } else {
            nurseId = (self.nurseInfo?.id)!
        }
        apiManager.getNurseLocation(nurseId) { (success, location, message) in
            if success == true {
                print("Api Called\(self.count)")
                dispatch_async(dispatch_get_main_queue(), { 
                    var long : Double = -117.000
                    var lat : Double = 36.000
                    if let strLong = location.objectForKey("last_longitud") as? String {
                        long = Double(strLong)!
                    }
                    if let strLat = location.objectForKey("last_latitud") as? String {
                        lat = Double(strLat)!
                    }
                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    self.lastNurseCoordinate = coord
                    self.getdirection(self.userCoordinate!, destCoord: coord)
//                    let annotation = NormalAnnotation(index: 0)
//                    annotation.coordinate = coord
//                    if self.vwMap.annotations.count > 0 {
//                        self.vwMap.removeAnnotations(self.vwMap.annotations)
//                    }
//                    self.vwMap.addAnnotation(annotation)
//                    let distance = self.determineDistance(self.centerPoint!, locationTwo: coord)
//                    let laddegree = (distance * 720) / ( 6371 * M_PI)
//                    print("distance = \(distance) radian = \(laddegree)")
//                    let region = MKCoordinateRegionMake(self.centerPoint!, MKCoordinateSpanMake(0.54, 0.54))
//                    print("region = \(region)")
//                    self.vwMap.setRegion(region, animated: true)
                    
                })
            }
        }
    }
    func stopTimer() {
        apiTimer.invalidate()
        
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.stopTimer()
        self.performSegueWithIdentifier("showBookingsVC", sender: nil)
    }
    @IBAction func actionGotoUserLocation(sender: AnyObject) {
        
    }
    func generateCustomPin(pinImg : UIImage, photo: UIImage) -> UIImage {
        var customPin : UIImage!
        let roundedImage : UIImage = self.maskRoundedImage(photo, radius: 13)
        UIGraphicsBeginImageContext(CGSizeMake(30, 45))
        pinImg.drawInRect(CGRectMake(0, 0, 30, 45))
        roundedImage.drawInRect(CGRectMake(2, 2, 26, 26))
        customPin = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return customPin
    }
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 26, 26))
        imageView.image = image
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    func generateSelectedAnnotation() -> SelectedAnnotation {
        let annotation = SelectedAnnotation(index: 0)
        let coord = CLLocationCoordinate2D(latitude: nurseInfo!.latitude!, longitude: nurseInfo!.longitude!)
        annotation.coordinate = coord
        return annotation
    }
    func getdirection (sourceCoord : CLLocationCoordinate2D, destCoord : CLLocationCoordinate2D) {
//        let coord = self.vwMap.userLocation.coordinate
        let aPicSource = MKPlacemark(coordinate: sourceCoord, addressDictionary: nil)
        let aPicDest = MKPlacemark(coordinate: destCoord, addressDictionary:nil)
        let mpItemSource = MKMapItem(placemark: aPicSource)
        let mpItemDest = MKMapItem(placemark: aPicDest)
        let sourceAnn = MKPointAnnotation()
        let destAnn = NormalAnnotation(index: 0)
        if let location = aPicSource.location {
            sourceAnn.coordinate = location.coordinate
        }
        if let location = aPicDest.location {
            destAnn.coordinate = location.coordinate
        }
        if self.vwMap.annotations.count > 0 {
            self.vwMap.removeAnnotations(self.vwMap.annotations)
        }
        self.vwMap.addAnnotations([sourceAnn,destAnn])
        self.vwMap.showAnnotations([sourceAnn,destAnn], animated: true)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = mpItemSource
        directionRequest.destination = mpItemDest
        directionRequest.transportType = .Automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculateDirectionsWithCompletionHandler { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
//            let mOverlay = MKOverlay()
            self.vwMap.addOverlay((route.polyline), level: MKOverlayLevel.AboveRoads)
//            self.vwMap.addOverlay(<#T##overlay: MKOverlay##MKOverlay#>)
            let rect = route.polyline.boundingMapRect
            self.vwMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TrackNurseVC : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView : MKAnnotationView!
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        if annotation.isKindOfClass(NormalAnnotation) {
            
//            let ann = annotation as? NormalAnnotation
//            let index = ann?.index
            let identifier = "normal"
//            let imagePin = imgPin
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let orgImg = nurseImage
            let newImage = self.generateCustomPin(self.imgSelectedPin!, photo: orgImg!)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = false
            annotationView.image = newImage
            annotationView.rightCalloutAccessoryView = detailButton
        }else if annotation.isKindOfClass(SelectedAnnotation) {
            
//            let ann = annotation as? SelectedAnnotation
//            let index = ann?.index
            let identifier = "selected"
            let orgImg = nurseImage
            let newImage = self.generateCustomPin(self.imgSelectedPin!, photo: orgImg!)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = false
            annotationView.image = newImage
            annotationView.rightCalloutAccessoryView = detailButton
        } else {
            return nil
        }
//        let userCoordinate = CLLocationCoordinate2D(latitude: self.userLatitude!, longitude: self.userLongitude!)
//        self.getdirection(userCoordinate)
        return annotationView
    }
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.userLatitude = userLocation.coordinate.latitude
        self.userLongitude = userLocation.coordinate.longitude
        self.userCoordinate = userLocation.coordinate
        self.getdirection(userLocation.coordinate, destCoord: self.lastNurseCoordinate)
    }
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 76 / 255, green: 155 / 255, blue: 234 / 255, alpha: 1)
        renderer.lineWidth = 4.0
        
        return renderer
    }
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        let annotation = view.annotation
//        if annotation!.isKindOfClass(NormalAnnotation) {
//            let ann = annotation as? NormalAnnotation
//        }
//    }
}