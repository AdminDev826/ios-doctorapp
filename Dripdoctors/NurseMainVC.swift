//
//  NurseMainVC.swift
//  Dripdoctors
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import MapKit
//import Mapbox

class NurseMainVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var lblUserCity: UILabel!
    @IBOutlet weak var lblUserState: UILabel!
    @IBOutlet weak var vwMap: MKMapView!
    @IBOutlet weak var vwMenu: UIView!
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
    @IBOutlet weak var scNurseAvailableServices: UIScrollView!
    @IBOutlet weak var btnBookingRequest: UIButton!
    @IBOutlet weak var vwServiceDetail: UIView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var imgServicePhoto: UIImageView!
    @IBOutlet weak var txtMobDes: UITextView!
    @IBOutlet weak var txtServDes: UITextView!
    @IBOutlet weak var scServList: UIScrollView!
    
    let apiManager = APIManager.sharedManager
    let locationManager = UserLocationManager.sharedManager
    
    var userCity = "New York"
    var userState = "CA"
    var uesrLongitude : Double = 34.0000
    var userLatitude : Double = -118.0000
    var nurseItems = [Nurse]()
    var currentNurse : Nurse!
    var nursePinImages = [UIImage]()
    var nurseOriginalImages = [UIImage]()
//    let imgPin = UIImage(named: "pin_normal")
    let imgSelectedPin = UIImage(named: "pin_selected")

    let imgPin = UIImage(named: "pin2")
    
    
    var visibleAnnotations = [MKAnnotation]()
    var currentSelectedNurseIndex : Int?
    var lastCenterPoint: CLLocationCoordinate2D?
    var lastZoomLevel: Double?
    var centerPoint: CLLocationCoordinate2D?
    var northWestPoint: CLLocationCoordinate2D?
    
    var isDrop = false
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NurseMainVC.loadPinsOnMap), name: "ImageLoadFinished.", object: nil)
        update()
        updateMap()
        loadNurseItems()
        // Do any additional setup after loading the view.
    }
    func updateMap() {
        
        vwMap.delegate = self
//        self.userLatitude = 34.0000
//        self.uesrLongitude = -118.0000
        centerPoint = CLLocationCoordinate2D(latitude: self.userLatitude, longitude: self.uesrLongitude)
        vwMap.showsUserLocation = true
        let region = MKCoordinateRegionMake(centerPoint!, MKCoordinateSpanMake(0.54, 0.54))
        print("region = \(region)")
        vwMap.setRegion(region, animated: true)
    }
    func update() {
        self.vwMenu.alpha = 0
        self.btnDrop.setBackgroundImage(UIImage(named: "drip_on"), forState: .Normal)
        if locationManager.city.characters.count > 0{
            self.userCity = locationManager.city
        }
        if locationManager.state.characters.count > 0 {
            self.userState = locationManager.state
        }
        if locationManager.longitude != nil {
            self.uesrLongitude = locationManager.longitude!
        }
        if locationManager.latitude != nil {
            self.userLatitude = locationManager.latitude!
        }
        self.lblUserCity.text = self.userCity
        self.lblUserState.text = self.userState
    }
    func loadPinsOnMap() {
        print("finished.")
        dispatch_async(dispatch_get_main_queue()) { 
            self.setupAnnocations()
        }
    }
    func reloadAnnotations(index : Int) {
        visibleAnnotations.removeAll()
        if self.nurseItems.count > 0 {
            for i in 0 ..< self.nurseItems.count {
                let item = self.nurseItems[i]
                if index == i {
                    let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
                    let annotation = SelectedAnnotation(index: i)
                    print("coordinate : \(coord)")
                    annotation.coordinate = coord
                    visibleAnnotations.append(annotation)
                } else {
                    let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
                    let annotation = NormalAnnotation(index: i)
                    print("coordinate : \(coord)")
                    annotation.coordinate = coord
                    visibleAnnotations.append(annotation)
                }
            }
        }
        if vwMap.annotations.count > 0 {
            vwMap.removeAnnotations(vwMap.annotations)
        }
        vwMap.addAnnotations(visibleAnnotations)
    }
    func setupAnnocations() {
        visibleAnnotations.removeAll()
        if vwMap.annotations.count > 0 {
            vwMap.removeAnnotations(vwMap.annotations)
        }
        if self.nurseItems.count > 0 {
            for i in 0 ..< self.nurseItems.count {
                let item = self.nurseItems[i]
//                if currentSelectedNurseIndex != nil && currentSelectedNurseIndex == i {
//                    let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
//                    let annotation = SelectedAnnotation(index: i)
//                    print("coordinate : \(coord)")
//                    annotation.coordinate = coord
//                    visibleAnnotations.append(annotation)
//                } else {
//                    let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
//                    let annotation = NormalAnnotation(index: i)
//                    print("coordinate : \(coord)")
//                    annotation.coordinate = coord
//                    visibleAnnotations.append(annotation)
//                }
                let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
                let annotation = NormalAnnotation(index: i)
                print("coordinate : \(coord)")
                annotation.coordinate = coord
                visibleAnnotations.append(annotation)
            }
        }
        vwMap.addAnnotations(visibleAnnotations)
        self.vwMap.showAnnotations(self.vwMap.annotations, animated: true)
    }
    func loadPinImages() {
        count = self.nurseItems.count
        for i in 0 ..< self.nurseItems.count {
            let nurseItem = self.nurseItems[i]
            if let img_Url = nurseItem.imgUrl {
                let url = NSURL(string: img_Url)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        self.nurseOriginalImages.append(image)
                        let newImage = self.generateCustomPin(self.imgPin!, photo: image)
                        self.nursePinImages.append(newImage)
                        self.count -= 1
                        if self.count == 0 {
                            NSNotificationCenter.defaultCenter().postNotificationName("ImageLoadFinished.", object: nil)
                        }
                    }
                    
                }).resume()
            }
        }
    }
    func loadNurseItems() {
        apiManager.getNurseItems("", completionHandler: { (success, items, message) in
            if success == true {
                dispatch_async(dispatch_get_main_queue(), { 
                    self.nurseItems = items
                    self.loadPinImages()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let atitle = NSAttributedString(string: "Error?", attributes: [
                        NSFontAttributeName : UIFont(name: "GothamPro-Medium", size: 15)!])
                    let amessage = NSAttributedString(string: "There are no any available nurse.", attributes: [
                        NSFontAttributeName : UIFont(name: "GoldenSans-Light", size: 12)!])
                    let alert = UIAlertController(title: "", message: "",  preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alert.addAction(action)
                    
                    alert.setValue(atitle, forKey: "attributedTitle")
                    alert.setValue(amessage, forKey: "attributedMessage")
                    self.presentViewController(alert, animated: false, completion: nil)
                })
                
            }
        })
    }
    @IBAction func actionDrip(sender: AnyObject) {
        if isDrop == false {
            self.btnDrop.setBackgroundImage(UIImage(named: "drip_off"), forState: .Normal)
            isDrop = true
            self.vwMenu.alpha = 1
        } else {
            self.btnDrop.setBackgroundImage(UIImage(named: "drip_on"), forState: .Normal)
            isDrop = false
            self.vwMenu.alpha = 0
        }
    }
    @IBAction func actionBookingRequest(sender: AnyObject) {
        
    }
    @IBAction func actionShowLocation(sender: AnyObject) {
        
    }
    @IBAction func actionService(sender: AnyObject) {
        self.performSegueWithIdentifier("showService", sender: nil)
    }
    @IBAction func actionBookings(sender: AnyObject) {
        self.performSegueWithIdentifier("showBookings", sender: nil)
    }
    @IBAction func actionAccount(sender: AnyObject) {
        
    }
    func showDetailView(index : Int) {
        self.vwNurseInfo.alpha = 1
        let item = nurseItems[index]
        self.imgNursePhoto.image = nurseOriginalImages[index]
        let strName = item.firstName +
            "  " +
            item.lastName
//            String(stringInterpolation: "%@ %@", item.firstName, item.lastName)
        print("Name = \(strName)")
        self.lblNurseName.text = strName
        let title = "Send " +
            item.firstName +
            " a Booking request"
//            String("Send %@ a Booking Request",item.firstName)
        self.btnBookingRequest.setTitle(title, forState: .Normal)
        self.showScore(item.score!)
        self.lblNurseOverview.text = "over " +
            item.review +
            " completed services"
//        self.loadServices(item.services)
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
    func generateSelectedAnnotation(index : Int) -> SelectedAnnotation {
        let annotation = SelectedAnnotation(index: index)
        let item = self.nurseItems[index]
        let coord = CLLocationCoordinate2D(latitude: item.latitude!, longitude: item.longitude!)
        annotation.coordinate = coord
        return annotation
    }
    func loadServices(services : [ServiceItem]){
        let subviews = self.scNurseAvailableServices.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        self.scNurseAvailableServices.contentOffset = CGPointZero
        if services.count > 0 {
            
        }
    }
    func showScore(score : Double) {
        if score < 2 {
            imgReview1.alpha = 1
            imgReview2.alpha = 0
            imgReview3.alpha = 0
            imgReview4.alpha = 0
            imgReview5.alpha = 0
        } else if score < 3 {
            imgReview1.alpha = 1
            imgReview2.alpha = 1
            imgReview3.alpha = 0
            imgReview4.alpha = 0
            imgReview5.alpha = 0
        } else if score < 4 {
            imgReview1.alpha = 1
            imgReview2.alpha = 1
            imgReview3.alpha = 1
            imgReview4.alpha = 0
            imgReview5.alpha = 0
        } else if score < 5 {
            imgReview1.alpha = 1
            imgReview2.alpha = 1
            imgReview3.alpha = 1
            imgReview4.alpha = 1
            imgReview5.alpha = 0
        } else {
            imgReview1.alpha = 1
            imgReview2.alpha = 1
            imgReview3.alpha = 1
            imgReview4.alpha = 1
            imgReview5.alpha = 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension NurseMainVC : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView : MKAnnotationView!
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        if annotation.isKindOfClass(NormalAnnotation) {
            
            let ann = annotation as? NormalAnnotation
            let index = ann?.index
            let identifier = "normal"
//            let imagePin = self.nursePinImages[index!]
            let orgImg = self.nurseOriginalImages[index!]
            let newImage = self.generateCustomPin(self.imgPin!, photo: orgImg)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = false
            annotationView.image = newImage
            annotationView.rightCalloutAccessoryView = detailButton
        } else {
            let imagePin = self.nursePinImages[0]
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.canShowCallout = false
            annotationView.image = imagePin
            annotationView.rightCalloutAccessoryView = detailButton
        }
//        else if annotation.isKindOfClass(SelectedAnnotation) {
//            
//            let ann = annotation as? SelectedAnnotation
//            let index = ann?.index
//            let identifier = "selected"
//            let orgImg = self.nurseOriginalImages[index!]
//            let newImage = self.generateCustomPin(self.imgSelectedPin!, photo: orgImg)
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.canShowCallout = false
//            annotationView.image = newImage
//            annotationView.rightCalloutAccessoryView = detailButton
//        } else {
//            let imagePin = self.nursePinImages[0]
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//            annotationView.canShowCallout = false
//            annotationView.image = imagePin
//            annotationView.rightCalloutAccessoryView = detailButton
//        }
        
        return annotationView
    }
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let annotation = view.annotation
        if annotation!.isKindOfClass(NormalAnnotation) {
            let ann = annotation as? NormalAnnotation
            let index = ann?.index
            currentSelectedNurseIndex = index
//            self.reloadAnnotations(currentSelectedNurseIndex!)
            self.showDetailView(currentSelectedNurseIndex!)
        }
    }
}
