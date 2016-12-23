//
//  ClientBookRequestVC.swift
//  Dripdoctors
//
//  Created by mac on 8/8/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ClientBookRequestVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwClinic: UIView!
    @IBOutlet weak var vwInHouse: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblTypePrice: UILabel!
    @IBOutlet weak var scInHouse: UIScrollView!
    @IBOutlet weak var imgUserLocationCheck: UIImageView!
    @IBOutlet weak var lblInHouseUserlocation: UILabel!
    @IBOutlet weak var imgInHouseSpecificAddressCheck: UIImageView!
    @IBOutlet weak var lblInHouseSpecificAddress: UILabel!
    @IBOutlet weak var lblInHouseSoonestTimeCheck: UIImageView!
    @IBOutlet weak var imgInHouseSpecificTimeCheck: UIImageView!
    @IBOutlet weak var lblInHouseSpecificTime: UILabel!
    
    
    @IBOutlet weak var scClinic: UIScrollView!
    @IBOutlet weak var lblClinicAddress: UILabel!
    @IBOutlet weak var imgClinicSoonestTime: UIImageView!
    @IBOutlet weak var imgClinicSpecificTimeCheck: UIImageView!
    @IBOutlet weak var lblClinicSpecificTimeCheck: UILabel!
    @IBOutlet weak var txtClinicSpecificTime: UITextField!
    @IBOutlet weak var scClinicList: UIScrollView!
    @IBOutlet weak var pickerClinicDate: UIDatePicker!
    @IBOutlet weak var lblClinicTitle1: UILabel!
    @IBOutlet weak var lblClinicTitle2: UILabel!
    @IBOutlet weak var txtHouseAddress: UITextField!
    @IBOutlet weak var scHouseDate: UIDatePicker!
    var isHouseSoonestTime = true
    var isUseMyLocation = true
    @IBOutlet weak var lbHouse_Adress: UILabel!
    @IBOutlet weak var lblHouseSoonestTime: UILabel!
    @IBOutlet weak var lblSetSpecificTime: UILabel!
    @IBOutlet weak var vwClinicPicker: UIView!
    @IBOutlet weak var vwHousePicker: UIView!
    
    let uiManager = UIManager.sharedManager
    let apiManager = APIManager.sharedManager
    let locationManager = UserLocationManager.sharedManager
    var currentHouseMode = false
    var clinics = [Clinic]();
    var currentClinic : Clinic!
    var currentClinicAddress = ""
    var isSoonestTime = true;
    var isUserLocation = false;
    var bookingDate : NSDate!
    
    var isShowDatePicker = false
    var isShowHouseDatePicker = false
    
    let check_Image = UIImage(named: "check_button")
    let uncheck_Image = UIImage(named: "uncheck_button")
    
    var userActualAddress : String!
    var userCity = ""
    var userState = ""
    var userPostalCode = ""
    var userLongitue : Double = -73.984638
    var userLatitude : Double = 40.759211
    
    var isHouseUserMode = true
    var isHouseSoonestMode = true
    
    var isClinic = true
    var callType = "clinic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadViewInfo()
    }
    func loadViewInfo() {
        imgInHouseSpecificTimeCheck.image = uncheck_Image
        imgInHouseSpecificAddressCheck.image = uncheck_Image
        imgUserLocationCheck.image = uncheck_Image
        lblInHouseSoonestTimeCheck.image = uncheck_Image
        
        if locationManager.city.characters.count > 0{
            self.userCity = locationManager.city
        }
        if locationManager.state.characters.count > 0 {
            self.userState = locationManager.state
        }
        if locationManager.postalCode.characters.count > 0 {
            self.userPostalCode = locationManager.postalCode
        }
        if locationManager.latitude != nil && locationManager.longitude != nil {
            self.userLongitue = locationManager.longitude!
            self.userLatitude = locationManager.latitude!
        }
        self.userActualAddress = self.getAddressData()
        if Singleton.sharedInstance.currentCategory != nil {
            self.lblTitle.text = Singleton.sharedInstance.currentCategory.category_name
            self.lblServiceName.text = Singleton.sharedInstance.currentCategory.category_name
            if Singleton.sharedInstance.serviceLogo != nil {
                imgLogo.image = Singleton.sharedInstance.serviceLogo
            } else {
                let strUrl = Singleton.sharedInstance.currentCategory.cat_image_url
                let url = NSURL(string: strUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        Singleton.sharedInstance.serviceLogo = image
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgLogo.image = image
                        })
                    }
                    
                }).resume()
            }
//            if Singleton.sharedInstance.currentCategory?.inhouse_call == true {
//                self.vwInHouse.backgroundColor = uiManager.selected_color
//                self.vwClinic.backgroundColor = uiManager.normal_color
//                currentHouseMode = true
//                self.scClinic.alpha = 0
//                self.scInHouse.alpha = 1
//                
//                self.imgInHouseSpecificTimeCheck.image = uncheck_Image
//                self.imgInHouseSpecificAddressCheck.image = uncheck_Image
//                self.imgUserLocationCheck.image = uncheck_Image
//                self.lblInHouseSoonestTimeCheck.image = uncheck_Image
//                
//                
//            } else {
//                self.vwInHouse.backgroundColor = uiManager.normal_color
//                self.vwClinic.backgroundColor = uiManager.selected_color
//                currentHouseMode = false
//            }
            apiManager.getClinicItems("", completionHandler: { (success, items, message) in
                if success == true {
                    self.clinics = items
                    dispatch_async(dispatch_get_main_queue(), {
                        if items.count > 0 {
                            let firstClinic = self.clinics.first
                            //                                let strAddress1 = (firstClinic?.address)! + "," + (firstClinic?.city)!
                            //                                let strAddress2 = strAddress1 + "," + (firstClinic?.state)!
                            //                                    "\(firstClinic?.address), \(firstClinic?.city), \(firstClinic?.state)"
                            let address = self.getClinicAddress(firstClinic!)
                            self.currentClinic = firstClinic
                            self.currentClinicAddress = address
                            self.lblClinicAddress.text = address
                            self.buildClinicList()
                            
                        }
                    })
                }
            })
            if Singleton.sharedInstance.isClientClinic == true {
                self.vwInHouse.backgroundColor = uiManager.normal_color
                self.vwClinic.backgroundColor = uiManager.selected_color
                isClinic = Singleton.sharedInstance.isClientClinic
                lblChooseOption.text = "Choose Clinic and Date / Time"
                callType = "clinic"
                self.scClinic.alpha = 1
                self.scInHouse.alpha = 0
                self.scClinicList.layer.borderColor = UIColor.blackColor().CGColor
                self.scClinicList.layer.borderWidth = 1
                
                
//                let date = NSDate()
//                self.pickerClinicDate.date = date
//                self.pickerClinicDate.layer.borderColor = UIColor.blackColor().CGColor
//                self.pickerClinicDate.layer.borderWidth = 1
                
                
            } else {
                lblChooseOption.text = "Choose User Location and Date/Time"
                self.vwInHouse.backgroundColor = uiManager.selected_color
                self.vwClinic.backgroundColor = uiManager.normal_color
                isClinic = Singleton.sharedInstance.isClientClinic
                callType = "house"
                self.scClinic.alpha = 0
                self.scInHouse.alpha = 1
                
            }
        }
        let date = NSDate()
        self.pickerClinicDate.date = date
        self.pickerClinicDate.layer.borderColor = UIColor.blackColor().CGColor
        self.pickerClinicDate.layer.borderWidth = 1
        
        self.scHouseDate.date = date
        self.scHouseDate.layer.borderColor = UIColor.blackColor().CGColor
        self.scHouseDate.layer.borderWidth = 1
        
        
        if Singleton.sharedInstance.currentRequestedService != nil {
            let service = Singleton.sharedInstance.currentRequestedService
            self.lblTypePrice.text = service.serviceName + ": $" + service.price!
        }
        self.isSoonestTime = true
        self.imgClinicSoonestTime.image = check_Image
        self.imgClinicSpecificTimeCheck.image = uncheck_Image
        self.imgUserLocationCheck.image = check_Image
        self.imgInHouseSpecificTimeCheck.image = uncheck_Image
        self.lblInHouseSoonestTimeCheck.image = check_Image
        self.imgInHouseSpecificAddressCheck.image = uncheck_Image
    }
    @IBAction func actionBackProducts(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionNext(sender: AnyObject) {
        
    }
    @IBAction func actionInHouseMyLocation(sender: AnyObject) {
        isUseMyLocation = true
        self.imgUserLocationCheck.image = check_Image
        self.imgInHouseSpecificAddressCheck.image = uncheck_Image
    }
    @IBAction func actionInHouseSpecificAddress(sender: AnyObject) {
        isUseMyLocation = false
        self.imgInHouseSpecificAddressCheck.image = check_Image
        self.imgUserLocationCheck.image = uncheck_Image
    }
    @IBAction func actionInHouseSnoonestTime(sender: AnyObject) {
        isHouseSoonestTime = true
        self.lblInHouseSoonestTimeCheck.image = check_Image
        self.imgInHouseSpecificTimeCheck.image = uncheck_Image
    }
    @IBAction func actionInHouseSpecificTime(sender: AnyObject) {
        isHouseSoonestTime = false
        self.lblInHouseSoonestTimeCheck.image = uncheck_Image
        self.imgInHouseSpecificTimeCheck.image = check_Image
    }
    @IBAction func actionShowHousePicker(sender: AnyObject) {
        if isShowHouseDatePicker == false {
            self.vwHousePicker.alpha = 1
            isShowHouseDatePicker = true
            lblHouseSoonestTime.alpha = 0
//            lblInHouseSpecificTime.alpha = 0
            lblSetSpecificTime.alpha = 0
            txtHouseAddress.alpha = 0
        } else {
            self.vwHousePicker.alpha = 0
            isShowHouseDatePicker = false
            lblHouseSoonestTime.alpha = 1
//            lblInHouseSpecificTime.alpha = 1
            lblSetSpecificTime.alpha = 1
            txtHouseAddress.alpha = 1
        }
    }
    @IBAction func actionHouseDateChanged(sender: AnyObject) {
        let date = self.scHouseDate.date
        bookingDate = date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.stringFromDate(date)
        self.lblInHouseSpecificTime.text = dateString
    }
    @IBAction func actionSubmit(sender: AnyObject) {
        var type = ""
        var isGPS : Bool?
        var lat : Double?
        var long : Double?
        var address = ""
        var clinicId = ""
        var timeType : Bool
        var book_date : NSDate?
        var servId = ""
        var userId = ""
        var amount = ""
        
        let transactionType = true
        let transactionCode = "12345"
        
        if isClinic == true {
            type = "clinic"
            if currentClinic == nil {
                clinicId = "1"
            } else {
                clinicId = currentClinic.id
            }
            isGPS = true
            timeType = isSoonestTime
            if isSoonestTime == true {
                book_date = NSDate()
            } else {
                
                if lblClinicSpecificTimeCheck.text?.characters.count > 0 {
                    if bookingDate != nil {
                        book_date = bookingDate
                    } else {
                        book_date = NSDate()
                    }
                } else {
                    let alert = showAlertView("Error?", message: "You need to put booking date/time.")
                    self.presentViewController(alert, animated: false, completion: nil)
                    return
                }
            }
            
        } else {
            type = "house"
            if isUseMyLocation == true {
                isGPS = true
            } else {
                
                if txtHouseAddress.text?.characters.count > 0 {
                    address = self.txtHouseAddress.text!
                } else {
                    let alert = showAlertView("Error?", message: "You need to put your address.")
                    self.presentViewController(alert, animated: false, completion: nil)
                    return
                }
            }
            timeType = isHouseSoonestTime
            if isHouseSoonestTime == true {
                book_date = NSDate()
            } else {
                if lblInHouseSpecificTime.text?.characters.count > 0 {
                    if bookingDate != nil {
                        book_date = bookingDate
                    } else {
                        book_date = NSDate()
                    }
                } else {
                    let alert = showAlertView("Error?", message: "You need to put booking date/time.")
                    self.presentViewController(alert, animated: false, completion: nil)
                    return
                }
            }
        }
        
//        isGPS = true
        lat = self.userLatitude
        long = self.userLongitue
//        address = self.userActualAddress
        
//        timeType = isSoonestTime
        
        if Singleton.sharedInstance.currentCategory != nil {
            servId = Singleton.sharedInstance.currentCategory.category_id
        }
        
        if Singleton.sharedInstance.user != nil {
            userId = Singleton.sharedInstance.user.id!
        }
        if Singleton.sharedInstance.currentRequestedService != nil {
            amount = Singleton.sharedInstance.currentRequestedService.price!
        }
        
        apiManager.sendBookingRequest(type, isGPS: isGPS!, lat: lat!, long: long!, address: address, clinicId: clinicId, timeType: timeType, date: book_date!, serviceId: servId, userId: userId, transactionType: transactionType, transactionCode:transactionCode,amount: amount) { (success, message) in
            if success == true {
                print("success")
                dispatch_async(dispatch_get_main_queue(), { 
                    self.performSegueWithIdentifier("showRequestConfirmVC", sender: nil)
                })
            } else {
                print("\(message)")
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = self.showAlertView("Error?", message: message!)
                    self.presentViewController(alert, animated: false, completion: nil)
                })
            }
        }
        
    }
    @IBOutlet weak var lblChooseOption: UILabel!
    @IBAction func actionCancel(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionClinic(sender: AnyObject) {
        if isClinic == false {
            isClinic = true
            lblChooseOption.text = "Choose Clinic and Date / Time"
            Singleton.sharedInstance.isClientClinic = true
            callType = "clinic"
            self.vwInHouse.backgroundColor = uiManager.normal_color
            self.vwClinic.backgroundColor = uiManager.selected_color
            self.scClinic.alpha = 1
            self.scInHouse.alpha = 0
        }
    }
    @IBAction func actionInHouseCall(sender: AnyObject) {
        if isClinic == true {
            lblChooseOption.text = "Choose User Location and Date/Time"
            self.vwInHouse.backgroundColor = uiManager.selected_color
            self.vwClinic.backgroundColor = uiManager.normal_color
            isClinic = false
            Singleton.sharedInstance.isClientClinic = false
            callType = "house_call"
            self.scClinic.alpha = 0
            self.scInHouse.alpha = 1
        }
    }
    @IBAction func clinicDateChaged(sender: UIDatePicker) {
        let date = self.pickerClinicDate.date
        bookingDate = date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.stringFromDate(date)
        self.lblClinicSpecificTimeCheck.text = dateString
    }
    @IBAction func actionShowClinicDate(sender: AnyObject) {
        if isShowDatePicker == false {
            self.vwClinicPicker.alpha = 1
            isShowDatePicker = true
            lblClinicTitle1.alpha = 0
            lblClinicTitle2.alpha = 0
        } else {
            self.vwClinicPicker.alpha = 0
            isShowDatePicker = false
            lblClinicTitle1.alpha = 1
            lblClinicTitle2.alpha = 1
        }
        
    }
    @IBAction func actionClinicCall(sender: AnyObject) {
    }
    @IBAction func actionHouse(sender: AnyObject) {
//        callType =
    }
    @IBAction func actionClinicSoonestTime(sender: AnyObject) {
        isSoonestTime = true
        self.imgClinicSoonestTime.image = check_Image
        self.imgClinicSpecificTimeCheck.image = uncheck_Image
    }
    
    @IBAction func showClinicList(sender: AnyObject) {
        self.scClinicList.alpha = 1
    }
    @IBAction func actionClinicSpecificTime(sender: AnyObject) {
        isSoonestTime = false
        self.imgClinicSpecificTimeCheck.image = check_Image
        self.imgClinicSoonestTime.image = uncheck_Image
    }
    func buildClinicList(){
        let scSize = self.scClinicList.frame.size
        for i in 0 ..< self.clinics.count {
            let item = self.clinics[i]
            let address = self.getClinicAddress(item)
            let vwCell = UIView(frame: CGRectMake(0,50 * CGFloat(i),scSize.width,50))
            let lblCell = UILabel(frame: CGRectMake(0,1,scSize.width,48))
            let imgSplit = UIImageView(frame: CGRectMake(0,49,scSize.width,1))
            let button = UIButton(frame: CGRectMake(0,0,scSize.width,50))
            button.tag = i
            button.addTarget(self, action: #selector(ClientBookRequestVC.clickClinic(_:)), forControlEvents: .TouchUpInside)
            
            imgSplit.image = UIImage(named: "spline_2")
            lblCell.textAlignment = .Center
//            lblCell.font = UIFont.systemFontOfSize(14)
            lblCell.font = UIFont(name: "GothamPro-Light", size: 14)
            lblCell.text = address
            
            vwCell.addSubview(lblCell)
            vwCell.addSubview(imgSplit)
            vwCell.addSubview(button)
            
            self.scClinicList.addSubview(vwCell)
            
        }
        self.scClinicList.contentSize = CGSizeMake(scSize.width, 50 * CGFloat(self.clinics.count))
    }
    func clickClinic(sender : UIButton) {
        let tag = sender.tag
        let clinic = self.clinics[tag]
        self.currentClinic = clinic
        currentClinicAddress = self.getClinicAddress(clinic)
        lblClinicAddress.text = currentClinicAddress
        self.scClinicList.alpha = 0
    }
    func getAddressData() -> String {
        var address = ""
        address = address + self.userCity + ","
        address = address + self.userPostalCode + ","
        address = address + self.userState
        return address
    }
    func getClinicAddress(clinic : Clinic) -> String {
        var address = ""
        address = address + clinic.address + ","
        address = address + clinic.city + ","
        address = address + clinic.state
        return address
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlertView(title : String, message : String) -> UIAlertController{
        let atitle = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont(name: "GothamPro-Medium", size: 15)!])
        let amessage = NSAttributedString(string: message, attributes: [
            NSFontAttributeName : UIFont(name: "GoldenSans-Light", size: 12)!])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        
        alert.setValue(atitle, forKey: "attributedTitle")
        alert.setValue(amessage, forKey: "attributedMessage")
        
        return alert
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
extension ClientBookRequestVC : UITextViewDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}