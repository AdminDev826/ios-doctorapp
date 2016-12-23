//
//  ClientServiceVC.swift
//  Dripdoctors
//
//  Created by mac on 7/31/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ClientServiceVC: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var vwTopbar: UIView!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var imgFindNurse: UIImageView!
    @IBOutlet weak var imgBooking: UIImageView!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var scService: UIScrollView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var imgToggle: UIImageView!
    
    var category_list = [ServiceCategory]();
    let apiManager = APIManager.sharedManager
    let reachabilityHander = ReachabilityHandler()
    var isToggle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        apiManager.getServiceCategory { (success, category, message) in
            NSLog("log");
            if (success == true) {
                self.category_list = category
                dispatch_async(dispatch_get_main_queue(), { 
                    self.buildScrollView()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { 
                    let alert = self.showMessage("Error?", message: "Something went wrong")
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }
    }
    func initializeUI() {
        Singleton.sharedInstance.clientMode = .Service
        imgService.image = UIImage(named: "service_selected")
        vwMenu.alpha = 1
        imgToggle.image = UIImage(named: "drip_off")
        if Singleton.sharedInstance.user != nil {
            let user = Singleton.sharedInstance.user
            lblUserName.text = user.firstName! + " " + user.lastName!
        }
        if UserLocationManager.sharedManager.city.characters.count > 0 && UserLocationManager.sharedManager.state.characters.count > 0 {
            let city = UserLocationManager.sharedManager.city
            let state = UserLocationManager.sharedManager.state
            lblUserLocation.text = city + " " + state
        } else {
            lblUserLocation.text = "Los Angeles, LA"
        }
//        if Singleton.sharedInstance.user.firstName != nil && Singleton.sharedInstance.user.lastName != nil {
//            lblUserName.text = Singleton.sharedInstance.user.firstName! + Singleton.sharedInstance.user.lastName!
//        }
//        if Singleton.sharedInstance.user.city != nil {
//            lblUserLocation.text = Singleton.sharedInstance.user.city
//        }
    }
    func buildScrollView(){
        if category_list.count > 0 {
            for i in 0  ..< category_list.count {
                let cat = category_list[i]
                let imgUrl = cat.cat_image_url
                let scSize = self.scService.frame.size
                let row = i / 2
                let column = i % 2
                let vwFrame = CGRectMake((scSize.width * CGFloat(column)) / 2, (scSize.width * CGFloat(row)) / 2, scSize.width / 2, scSize.width / 2)
                var imgFrame : CGRect?
                if column == 0 {
                    imgFrame = CGRectMake(10, 10, vwFrame.size.width - 15, vwFrame.size.height - 15)
                } else {
                    imgFrame = CGRectMake(5, 10, vwFrame.size.width - 15, vwFrame.size.height - 15)
                }
                let vwCell = UIView(frame: vwFrame)
                let imgCell = UIImageView(frame: imgFrame!)
                let button = UIButton(frame: CGRectMake(0, 0, vwFrame.size.width, vwFrame.size.height))
                button.tag = i
                button.addTarget(self, action: #selector(ClientServiceVC.gotoService(_:)), forControlEvents: .TouchUpInside)
                let url = NSURL(string: imgUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        dispatch_async(dispatch_get_main_queue(), {
                            imgCell.image = image
                        })
                    }
                    
                }).resume()
                vwCell.addSubview(imgCell)
                vwCell.addSubview(button)
                self.scService.addSubview(vwCell)
            }
            let imgColumnCount = (category_list.count + 1) / 2
            scService.contentSize = CGSizeMake(self.scService.frame.size.width, self.scService.frame.size.width * CGFloat(imgColumnCount) / 2)
        }
    }
    @IBAction func actionLocationView(sender: UIButton) {
    }
    @IBAction func actionService(sender: AnyObject) {
    }
    @IBAction func actionFindNurse(sender: AnyObject) {
        self.performSegueWithIdentifier("showFindNurse", sender: nil)
    }
    @IBAction func actionBooking(sender: AnyObject) {
        self.performSegueWithIdentifier("showBookings", sender: nil)
    }
    @IBAction func actionAccount(sender: AnyObject) {
    }
    @IBAction func actionToggle(sender: AnyObject) {
        if isToggle == false {
            isToggle = true
            imgToggle.image =  UIImage(named: "drip_on")
            self.vwMenu.alpha = 0
        } else {
            isToggle = false
            imgToggle.image =  UIImage(named: "drip_off")
            self.vwMenu.alpha = 1
        }
    }
    func gotoService(sender : UIButton){
        let tag = sender.tag as Int
        let cat = category_list[tag]
        Singleton.sharedInstance.currentCategory = cat
        performSegueWithIdentifier("showService", sender: nil)
    }
    func showMessage(title : String, message : String) -> UIAlertController{
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? ServiceVC {
//            destination.category = sender as? ServiceCategory∂
        }
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
