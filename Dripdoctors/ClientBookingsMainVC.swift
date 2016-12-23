//
//  ClientBookingsMainVC.swift
//  Dripdoctors
//
//  Created by mac on 8/17/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

enum CurrentSelectedMode {
    case Initial
    case All
    case Pending
    case Confirmed
    case Declined
}
class ClientBookingsMainVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var btnDrip: UIButton!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var vwToolbar: UIView!
    @IBOutlet weak var vwAll: UIView!
    @IBOutlet weak var vwConfirmed: UIView!
    @IBOutlet weak var vwPending: UIView!
    @IBOutlet weak var vwDeclined: UIView!
    @IBOutlet weak var vwBottombar: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var vwToolbarTop: NSLayoutConstraint!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var vwMessageBottom: NSLayoutConstraint!
    @IBOutlet weak var txtMessageBox: UITextField!
    @IBOutlet weak var vwTryOption: UIView!
    @IBOutlet weak var btnTryAgain: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    let def_min_constant : CGFloat = 35
    let def_max_constant : CGFloat = 85
    let apiManager = APIManager.sharedManager
    let locationManager = UserLocationManager.sharedManager
    
    var availableBookings = [Booking]()
    var confirmedBookings = [Booking]()
    var pendingBookings = [Booking]()
    var declinedBookings = [Booking]()
    
    var userCity = "Los Angeles"
    var userState = "CA"
    var zipCode = ""
    
    var bookings = [Booking]()
    var currentSelectedTag : Int?
    var customViews = [CustomBookingCell]()
    var keyboardHeight : CGFloat = 216
    var currentSelectedBooking : Booking?
    var currentUIMode : CurrentSelectedMode? {
        didSet {
            self.UIUpdateByCurrentMode()
        }
    }
    var isDrop : Bool? {
        didSet {
            self.showToolBar()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ClientBookingsMainVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        isDrop = true
        userLocationSetup()
        loadBookingItems()
    }
    func keyboardWillShow(notification : NSNotification) {
        let userInfo : NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRecangle = keyboardFrame.CGRectValue()
        print("Keyboard Frame : \(keyboardRecangle)")
        self.keyboardHeight = keyboardRecangle.height
        dispatch_async(dispatch_get_main_queue()) { 
            self.vwMessageBottom.constant = self.keyboardHeight
        }
    }
    func userLocationSetup() {
        if locationManager.city.characters.count > 0 {
            self.userCity = locationManager.city
        }
        if locationManager.state.characters.count > 0 {
            self.userState = locationManager.state
        }
    }
    func loadBookingItems() {
        apiManager.getBookingItems(Singleton.sharedInstance.user.id!, bookingId: "") { (success, items, message) in
            if success == true {
                print("Book Item : \(items)")
                self.availableBookings = items
                self.filterBookingItems()
                dispatch_async(dispatch_get_main_queue(), { 
                    if (self.availableBookings.count > 0) {
                        self.currentUIMode = .All
                    } else {
                        self.currentUIMode = .Initial
                    }
//                    self.currentUIMode = .Initial
                })
//                NSNotificationCenter.defaultCenter().postNotificationName("BookingItemLoadFinished", object: nil)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = self.showAlertView("Error?", message: message!)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    @IBAction func actionDrip(sender: AnyObject) {
        if isDrop == false {
            btnDrip.setBackgroundImage(UIImage(named: "drip_off"), forState: .Normal)
            isDrop = true
        } else {
            btnDrip.setBackgroundImage(UIImage(named: "drip_on"), forState: .Normal)
            isDrop = false
        }
    }
    func filterBookingItems() {
        if self.availableBookings.count > 0 {
            for item in self.availableBookings {
                let statusType = item.status
                if statusType == 1 {
                    self.pendingBookings.append(item)
                } else if statusType == 2 {
                    self.confirmedBookings.append(item)
                } else {
                    self.declinedBookings.append(item)
                }
            }
        }
        print("Pending Count : \(pendingBookings.count), Confirmed Count : \(confirmedBookings.count), Declined Count : \(declinedBookings.count)")
        print("OK")
    }
    func showToolBar() {
        if isDrop == true {
            vwToolbarTop.constant = def_max_constant
            self.vwMenu.alpha = 1
        } else {
            vwToolbarTop.constant = def_min_constant
            self.vwMenu.alpha = 0
        }
    }
    func UIUpdateByCurrentMode() {
        if currentUIMode == .Initial {
            bookings = []
            self.vwBottombar.alpha = 1
            let alert = showAlertView("You do not have any bookings yet", message: "Note: You have to apply for any of our services first. Then you will be able to see them in your bookings section.")
            self.presentViewController(alert, animated: true, completion: nil)
        } else if currentUIMode == .All {
            self.vwBottombar.alpha = 0
            bookings = availableBookings
            self.buildScrollView()
//            self.mainCollectionView.reloadData()
        } else if currentUIMode == .Pending {
            self.vwBottombar.alpha = 0
            bookings = pendingBookings
            self.buildScrollView()
//            self.mainCollectionView.reloadData()
        } else if currentUIMode == .Confirmed {
            self.vwBottombar.alpha = 0
            bookings = confirmedBookings
            self.buildScrollView()
//            self.mainCollectionView.reloadData()
        } else if currentUIMode == .Declined {
            self.vwBottombar.alpha = 0
            bookings = declinedBookings
            self.buildScrollView()
//            self.mainCollectionView.reloadData()
        }
    }
    @IBAction func actionService(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionFindNurse(sender: AnyObject) {
        self.performSegueWithIdentifier("showFindNurse", sender: nil)
    }
    @IBAction func actionAccount(sender: AnyObject) {
        
    }
    @IBAction func actionAll(sender: AnyObject) {
        if currentUIMode != .All {
            self.vwTryOption.alpha = 0
            self.vwAll.backgroundColor = UIManager.sharedManager.selected_color
            self.vwConfirmed.backgroundColor = UIManager.sharedManager.normal_color
            self.vwPending.backgroundColor = UIManager.sharedManager.normal_color
            self.vwDeclined.backgroundColor = UIManager.sharedManager.normal_color
            self.currentSelectedTag = nil
            currentUIMode = .All
        }
    }
    @IBAction func actionConfirmed(sender: AnyObject) {
        if currentUIMode != .Confirmed {
            self.vwTryOption.alpha = 0
            self.vwAll.backgroundColor = UIManager.sharedManager.normal_color
            self.vwConfirmed.backgroundColor = UIManager.sharedManager.selected_color
            self.vwPending.backgroundColor = UIManager.sharedManager.normal_color
            self.vwDeclined.backgroundColor = UIManager.sharedManager.normal_color
            currentUIMode = .Confirmed
        }
    }
    @IBAction func actionDeclined(sender: AnyObject) {
        if currentUIMode != .Declined {
            self.vwAll.backgroundColor = UIManager.sharedManager.normal_color
            self.vwConfirmed.backgroundColor = UIManager.sharedManager.normal_color
            self.vwPending.backgroundColor = UIManager.sharedManager.normal_color
            self.vwDeclined.backgroundColor = UIManager.sharedManager.selected_color
            self.currentSelectedTag = nil
            currentUIMode = .Declined
        }
    }
    @IBAction func actionPending(sender: AnyObject) {
        if currentUIMode != .Pending {
            self.vwTryOption.alpha = 0
            self.vwAll.backgroundColor = UIManager.sharedManager.normal_color
            self.vwConfirmed.backgroundColor = UIManager.sharedManager.normal_color
            self.vwPending.backgroundColor = UIManager.sharedManager.selected_color
            self.vwDeclined.backgroundColor = UIManager.sharedManager.normal_color
            self.currentSelectedTag = nil
            currentUIMode = .Pending
        }
    }
    func showOptionsView(sender : UIButton) {
//        let index = sender.tag
        self.currentSelectedTag = sender.tag
        self.mainCollectionView.reloadData()
    }
    func buildScrollView() {
        let subViews = self.mainScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        customViews = [CustomBookingCell]()
        if bookings.count > 0 {
            let scSize = self.mainScrollView.frame.size
            for i in 0..<bookings.count {
                let vwrect = CGRectMake(0, CGFloat(200 * i), scSize.width, 200)
                let customCell = CustomBookingCell(frame: vwrect)
                customCell.setViewTag(i)
                customCell.btnOption.addTarget(self, action: #selector(ClientBookingsMainVC.hidePreviousView(_:)), forControlEvents: .TouchUpInside)
                customCell.btnEdit.addTarget(self, action: #selector(ClientBookingsMainVC.editButtonPressed(_:)), forControlEvents: .TouchUpInside)
                customCell.btnSendMessage.addTarget(self, action:#selector(ClientBookingsMainVC.sendMessageButtonPressed(_:)), forControlEvents: .TouchUpInside)
                customCell.btnCancelBooking.addTarget(self, action: #selector(ClientBookingsMainVC.cancelBookingButtonPressed(_:)), forControlEvents: .TouchUpInside)
                customViews.append(customCell)
                self.mainScrollView.addSubview(customCell)
                if currentUIMode == .All {
                    customCell.btnEdit.setTitle("Track Nurse", forState: .Normal)
                }
                let item = self.bookings[i]
                if item.isEmptyService == true {
                    let serv = item.serviceInfo
                    if let imgUrl = serv?.cat_image_url {
                        let url = NSURL(string: imgUrl)
                        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                            if data != nil && error == nil {
                                let image : UIImage = UIImage(data: data!)!;
                                dispatch_async(dispatch_get_main_queue(), {
                                    customCell.imgServLogo.image = image
                                })
                            }
                            
                        }).resume()
                    }
                    if let strServName = serv?.category_name {
                        customCell.lblServName.text = strServName
                    }
                }
                if item.isEmptyProd == true {
                    let prodInfo = item.productInfo
                    let str = (prodInfo?.serviceName)! + ": $ " + (prodInfo?.price)!
                    print("Product Information : \(prodInfo)")
                    customCell.lblProdInfo.text = str
                }
                if item.nurseIdAssigned == true {
                    let nurseInfo = item.nurseInfo
                    let _imgUrl = nurseInfo?.imgUrl
                    if  _imgUrl!.characters.count > 0{
                        let url = NSURL(string: _imgUrl!)
                        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                            if data != nil && error == nil {
                                let image : UIImage = UIImage(data: data!)!;
                                dispatch_async(dispatch_get_main_queue(), {
                                    customCell.imgNursePhoto.image = image
                                })
                            }
                            
                        }).resume()
                    }
                    let name = (nurseInfo?.firstName)! + " " +  (nurseInfo?.lastName)!
                    print("Name : \(name)")
                    customCell.lblNurseName.text = name
                } else {
                    customCell.vwNurse.alpha = 0
                }
                if item.bookingdateTime != nil {
//                    customCell.lblbookingDate.text = item.booking_date + " " + item.booking_time
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = .LongStyle
                    formatter.timeStyle = .MediumStyle
                    customCell.lblbookingDate.text = formatter.stringFromDate(item.bookingdateTime!)
                }
                if item.bookingType == true {
                    customCell.lblCallType.text = "CLINIC CALL"
                } else {
                    customCell.lblCallType.text = "HOUSE CALL"
                }
                if let address = item.client_address as? String where address.characters.count > 0 {
                    customCell.lblAddress.text = address
                } else {
                    let address = self.userCity + " " + self.userState
                    print("address : \(address)")
                    customCell.lblAddress.text = address
                }
                if item.status == 1 {
                    customCell.lblBookingStatus.text = "Pending Confirmation"
                } else if item.status == 2 {
                    customCell.lblBookingStatus.text = "Confirmed"
                } else {
                    customCell.lblBookingStatus.text = "Declined"
                }
                
            }
            self.mainScrollView.contentSize = CGSizeMake(scSize.width, CGFloat(200 * bookings.count))
        }
    }
    @IBAction func actionRemove(sender: AnyObject) {
        let tag = sender.tag
        if let bookingitem = bookings[tag] as? Booking {
            self.apiManager.sendRemoveBooking(bookingitem.bookingId, closure: { (success, message) in
                if success == true {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.bookings.removeAtIndex(tag)
                        self.removeItemFromAll(bookingitem)
                        self.buildScrollView()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        let alert = self.showAlertView("Error?", message: "There are some errors.")
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    })
                }
            })
        }
    }
    @IBAction func actionTryagain(sender: AnyObject) {
        let tag = sender.tag
        if bookings.count == 0 {
            return
        }
        if let bookingitem = bookings[tag] as? Booking {
            self.apiManager.bookingApplyAgain(bookingitem.bookingId, bookingDate: bookingitem.booking_date, bookingTime: bookingitem.booking_time, transCode: bookingitem.transCode, transType: bookingitem.transType, closure: { (success, message) in
                if success == true {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.bookings.removeAtIndex(tag)
                        bookingitem.status = 1
                        self.pendingBookings.append(bookingitem)
                        self.buildScrollView()
                    })
                } else {
                    let alert = self.showAlertView("Error?", message: "Failed to add booking")
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }
    }
    func removeItemFromAll(item : Booking) {
        if let index = self.availableBookings.indexOf(item) {
            self.availableBookings.removeAtIndex(index)
        }
    }
    func hidePreviousView(sender : UIButton){
        if currentUIMode == .Declined {
            self.btnTryAgain.tag = sender.tag
            self.btnRemove.tag = sender.tag
            self.vwTryOption.alpha = 0.95
        } else if currentUIMode == .All {
            let tag = sender.tag
            let bookingItem = bookings[tag]
            if bookingItem.status == 3 {
                for i in 0..<customViews.count {
                    let vw = customViews[i]
                    vw.hideVwEditting()
                }
                self.vwTryOption.alpha = 0.95
                self.btnTryAgain.tag = sender.tag
                self.btnRemove.tag = sender.tag
            } else {
                self.vwTryOption.alpha = 0
                for i in 0..<customViews.count {
                    let vw = customViews[i]
                    vw.hideVwEditting()
                }
                let currentVw = sender.superview as! CustomBookingCell
                currentVw.showVwEditing()
                currentSelectedTag = sender.tag
            }
        } else {
            if currentSelectedTag != nil {
                let prevView = customViews[currentSelectedTag!]
                prevView.hideVwEditting()
            }
            let currentVw = sender.superview as! CustomBookingCell
            currentVw.showVwEditing()
            currentSelectedTag = sender.tag
        }
    }
    @IBAction func actionSendMessage(sender: AnyObject) {
        let user = Singleton.sharedInstance.user
        apiManager.bookingSendMessage(user.id!, nurseId: (self.currentSelectedBooking?.nurseId)!, msgDescription: self.txtMessageBox.text!) { (success, message) in
            if success == true {
                print("Sent the message to Nurse.")
            } else {
                print("Failed to send message to Nurse.")
            }
        }
    }
    func editButtonPressed(sender : UIButton) {
        let tag = sender.tag
        self.currentSelectedBooking = self.bookings[tag]
        Singleton.sharedInstance.currentClientSelectedBookingItem = self.currentSelectedBooking
        if currentUIMode == .All {
            self.performSegueWithIdentifier("showTrackNurse", sender: nil)
        } else {
            self.performSegueWithIdentifier("showEditBooking", sender: nil)
        }
        
    }
    func sendMessageButtonPressed(sender : UIButton) {
        let tag = sender.tag
        self.currentSelectedBooking = self.bookings[tag]
        self.vwMessage.alpha = 1
    }
    func cancelBookingButtonPressed(sender : UIButton) {
        let tag = sender.tag
        self.currentSelectedBooking = self.bookings[tag]
        Singleton.sharedInstance.currentClientSelectedBookingItem = self.currentSelectedBooking;
        let cancelBookingController = self.storyboard!.instantiateViewControllerWithIdentifier("cancelBooking") as! UIViewController
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: cancelBookingController)
        formSheetController.presentationController?.contentViewSize = CGSizeMake(248, 175)
        formSheetController.contentViewControllerTransitionStyle = .Fade
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.presentationController?.shouldCenterHorizontally = true
        self.presentViewController(formSheetController, animated: true, completion: nil)
//        self.performSegueWithIdentifier("showCancelBookingVC", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
extension ClientBookingsMainVC : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        UIView.animateWithDuration(1.0) {
            self.vwMessageBottom.constant = 0
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        UIView.animateWithDuration(1.0) {
            self.vwMessage.alpha = 1
            self.vwMessageBottom.constant = self.keyboardHeight
        }
//        return true
    }
}
//extension ClientBookingsMainVC : UICollectionViewDataSource {
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let item = bookings[indexPath.row]
//        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("bookingCell", forIndexPath: indexPath) as! BookingsCell
////        let cell = BookingsCell(frame: CGRectMake(0, CGFloat(200 * indexPath.row),UIScreen.mainScreen().bounds.size.width,200 ))
//        if item.nurseIdAssigned == true {
//            if let imgUrl = item.nurseInfo?.imgUrl where imgUrl.characters.count > 0 {
//                let url = NSURL(string: imgUrl)
//                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//                    if data != nil && error == nil {
//                        let image : UIImage = UIImage(data: data!)!;
//                        dispatch_async(dispatch_get_main_queue(), {
//                            cell.imgNursePhoto.image = image
//                        })
//                    }
//                    
//                }).resume()
//            }
//        }
//        if let clinicInfo = item.clinicInfo {
//            if let address = clinicInfo.address as? String {
//                cell.lblAddress.text = address
//            }
//        }
//        
//        let statusType = item.status
//        if statusType == 1 {
//            cell.lblBookingType.text = "Booking Pending"
//        } else if statusType == 2 {
//            cell.lblBookingType.text = "Booking Confirmed"
//        } else {
//            cell.lblBookingType.text = "Booking Declined"
//        }
//        
//        cell.btnOptions.tag = indexPath.row
//        cell.btnOptions.addTarget(self, action: #selector(ClientBookingsMainVC.showOptionsView(_:)), forControlEvents: .TouchUpInside)
//        
//        print("Index Path Row : \(indexPath.row), Index Path Section : \(indexPath.section)")
//        
//        if currentSelectedTag != nil && indexPath.row == currentSelectedTag {
//            cell.vwEditing.alpha = 1
//        }
//        
//        return cell
//    }
//    func collectionView(collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 200)
//    }
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return bookings.count
//    }
//}
//extension ClientBookingsMainVC : UICollectionViewDelegate {
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("Selected Item : \(indexPath.row)")
//        
//    }
//}