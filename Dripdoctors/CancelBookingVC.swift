//
//  CancelBookingVC.swift
//  Dripdoctors
//
//  Created by mac on 8/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class CancelBookingVC: UIViewController {
    
    @IBOutlet weak var vwAlert: UIView!
    let apiManager = APIManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionClose(sender: AnyObject) {
        self.vwAlert.alpha = 0
        self.performSegueWithIdentifier("showBookingsVC", sender: nil)
    }
    @IBAction func actionConfirm(sender: AnyObject) {
        self.vwAlert.alpha = 0
        let bookingItem = Singleton.sharedInstance.currentClientSelectedBookingItem
        apiManager.cancelBooking((bookingItem?.bookingId)!, cancelId: Singleton.sharedInstance.currentCancelId) { (success, message) in
            if success == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showBookingsVC", sender: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let alert = self.showAlertView("Error?", message: "Failed to cancel booking")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.vwAlert.alpha = 0
        self.performSegueWithIdentifier("showBookingsVC", sender: nil)
    }
    @IBAction func actionCancelBooking(sender: AnyObject) {
//        self.vwAlert.alpha = 0
        let bookingItem = Singleton.sharedInstance.currentClientSelectedBookingItem
        apiManager.cancelBooking((bookingItem?.bookingId)!, cancelId: Singleton.sharedInstance.currentCancelId) { (success, message) in
            if success == true {
                dispatch_async(dispatch_get_main_queue(), { 
                    self.performSegueWithIdentifier("showBookingsVC", sender: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    let alert = self.showAlertView("Error?", message: "Failed to cancel booking")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
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
