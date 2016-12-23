//
//  LobbyRequestConfirmVC.swift
//  Dripdoctors
//
//  Created by mac on 8/10/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class LobbyRequestConfirmVC: UIViewController {

    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var imgServiceLogo: UIImageView!
    @IBOutlet weak var imgServiceItemLogo: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var txtConfirmMessage: UITextView!
    @IBOutlet weak var vwClinic: UIView!
    @IBOutlet weak var vwHouseCall: UIView!
    var isClinic = false
    let uiManager = UIManager.sharedManager
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtConfirmMessage.userInteractionEnabled = false
        self.loadViewItems()
        // Do any additional setup after loading the view.
    }
    func loadViewItems() {
        isClinic = Singleton.sharedInstance.isClientClinic
        if isClinic == true {
            self.vwHouseCall.backgroundColor = uiManager.normal_color
            self.vwClinic.backgroundColor = uiManager.selected_color
        } else {
            self.vwHouseCall.backgroundColor = uiManager.selected_color
            self.vwClinic.backgroundColor = uiManager.normal_color
        }
        if Singleton.sharedInstance.currentCategory != nil {
            self.lblServiceTitle.text = Singleton.sharedInstance.currentCategory.category_name
            self.lblServiceName.text = Singleton.sharedInstance.currentCategory.category_name
            if Singleton.sharedInstance.serviceLogo != nil {
                self.imgServiceLogo.image = Singleton.sharedInstance.serviceLogo
            } else {
                let strUrl = Singleton.sharedInstance.currentCategory.cat_image_url
                let url = NSURL(string: strUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        Singleton.sharedInstance.serviceLogo = image
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgServiceLogo.image = image
                        })
                    }
                    
                }).resume()
            }
            if Singleton.sharedInstance.serviceItemLogo != nil {
                self.imgServiceItemLogo.image = Singleton.sharedInstance.serviceItemLogo
            } else {
                let strUrl = Singleton.sharedInstance.currentRequestedService.imageUrl
                let url = NSURL(string: strUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        Singleton.sharedInstance.serviceItemLogo = image
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgServiceItemLogo.image = image
                        })
                    }
                    
                }).resume()
            }
        }
    }
    @IBAction func actionServices(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionNext(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionBookings(sender: AnyObject) {
        self.performSegueWithIdentifier("showBookings", sender: nil)
    }
    @IBAction func actionAnotherService(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
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
