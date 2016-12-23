//
//  ServiceVC.swift
//  Dripdoctors
//
//  Created by mac on 8/3/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ServiceVC: UIViewController,iCarouselDelegate,iCarouselDataSource {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwTitle: UIView!
    @IBOutlet weak var vwServiceInfo: UIView!
    @IBOutlet weak var vwCarouCell: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var imgServiceLog: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServiceIntro: UILabel!
    @IBOutlet weak var vwClinic: UIView!
    @IBOutlet weak var vwHouseCall: UIView!
    @IBOutlet weak var carou_view: iCarousel!
    
    
    @IBOutlet weak var vwDetail: UIScrollView!
//    @IBOutlet weak var vwDetailContentHeight: NSLayoutConstraint!
    @IBOutlet weak var vwDetailContent: UIView!
    @IBOutlet weak var lblServiceTitle: UILabel!
    @IBOutlet weak var txtServiceDescription: UITextView!
    
//    @IBOutlet weak var txtSevDescriptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgDetailLogo: UIImageView!
    @IBOutlet weak var imgDetailLogoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var txtMobDescription: UITextView!
//    @IBOutlet weak var txtMobDescriptionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scDetailItems: UIScrollView!
    
    
    
    let apiManager = APIManager.sharedManager
    let uiManager = UIManager.sharedManager
    var services = [ServiceItem]()
    var filteredService = [ServiceItem]()
    var category : ServiceCategory?
    var currentSelectedService : ServiceItem?
    var currentSelectedIndex : NSInteger!
    var isDetailLoad = false
    
    var isClinic = true
    var callType = "clinic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carou_view.type = .Rotary
        self.loadViewItems()
        self.loadItems()
        // Do any additional setup after loading the view.
    }
    func loadViewItems() {
        category = Singleton.sharedInstance.currentCategory
        if category != nil {
            self.lblTitle.text = category?.category_name
            self.lblServiceName.text = category?.category_name
            let subname = self.generateOthername((category?.category_id)!)
            self.lblServiceIntro.text = "CHOOSE YOUR " + subname
            let imgUrl = category?.cat_image_url
            let url = NSURL(string: imgUrl!)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if data != nil && error == nil {
                    let image : UIImage = UIImage(data: data!)!;
                    Singleton.sharedInstance.serviceLogo = image
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imgServiceLog.image = image
                    })
                }
                
            }).resume()
//            if category?.inhouse_call == true {
//                self.vwHouseCall.backgroundColor = uiManager.normal_color
//                self.vwClinic.backgroundColor = uiManager.selected_color
//            }
        }
    }
    func filterservices() {
        if services.count > 0 {
            for i in 0..<services.count {
                let item = services[i]
                if item.inhouseCall == true {
                    filteredService.append(item)
                }
            }
        }
        print("filtered service : \(filteredService)")
    }
    func loadItems() {
        if category != nil {
            apiManager.getServiceItems(category!.category_id, completionHandler: { (success, items, message) in
                if success == true {
                    self.services = items
                    self.filterservices()
                    Singleton.sharedInstance.currentServices = items
                    self.currentSelectedService = self.services[0];
                    dispatch_async(dispatch_get_main_queue(), {
                        self.carou_view.reloadData()
                        self.buildDetailView()
                    })
                }
            })
        }
    }
    func generateOthername(id : String) -> String {
        var catName = ""
        if id == "1" {
            catName = "DRIP"
        } else if id == "2" {
            catName = "BOOSTER"
        } else if id == "2" {
            catName = "COSMETIC"
        } else if id == "2" {
            catName = "MEMBERSHIP"
        } else if id == "2" {
            catName = "WEIGHT DOESNT WORK"
        } else if id == "2" {
            catName = "CONCIERGE"
        }
        return catName
    }
    @IBAction func actionInClinic(sender: AnyObject) {
        if isClinic == false {
            isClinic = true
            callType = "clinic"
            self.vwHouseCall.backgroundColor = uiManager.normal_color
            self.vwClinic.backgroundColor = uiManager.selected_color
            self.carou_view.reloadData()
        }
    }
    @IBAction func actionHouseCall(sender: AnyObject) {
        if isClinic == true {
            self.vwHouseCall.backgroundColor = uiManager.selected_color
            self.vwClinic.backgroundColor = uiManager.normal_color
            isClinic = false
            callType = "house_call"
            self.carou_view.reloadData()
        }
    }
    @IBAction func actionBack(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(false)
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionNext(sender: AnyObject) {
    }

    @IBAction func actionBook(sender: AnyObject) {
        Singleton.sharedInstance.isClientClinic = isClinic
        performSegueWithIdentifier("showBookingView", sender: currentSelectedIndex)
    }
    
    func showServiceDetail(sender : UIButton){
        if let item = services[sender.tag] as? ServiceItem {
            NSLog("Load detail")
            currentSelectedService = item
//            updateDetailView()
            self.scDetailItems.userInteractionEnabled = true;
            self.txtServiceDescription.userInteractionEnabled = false
            lblServiceTitle.text = item.serviceName
            txtServiceDescription.text = item.servicedescription
            if let imgUrl = item.imageUrl as? String {
                let url = NSURL(string: imgUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgDetailLogo.image = image
                        })
                    }
                    
                }).resume()
            }
            
            self.vwCarouCell.alpha = 0
            self.vwBottom.alpha = 0
            self.vwServiceInfo.alpha = 0
            self.vwDetail.alpha = 1
        }
    }
    @IBAction func actionCancelDetail(sender: AnyObject) {
        self.vwDetail.alpha = 0
        self.vwCarouCell.alpha = 1
        self.vwBottom.alpha = 1
        self.vwServiceInfo.alpha = 1
    }
    func updateDetailView() {
        
        self.vwCarouCell.alpha = 0
        self.vwBottom.alpha = 0
        self.vwServiceInfo.alpha = 0
        self.vwDetail.alpha = 1
    }
    @IBAction func actionShowServiceInfo(sender: AnyObject) {
        self.scDetailItems.userInteractionEnabled = true;
        self.txtServiceDescription.userInteractionEnabled = false
        lblServiceTitle.text = category?.category_name
        txtServiceDescription.text = category?.category_description
        if Singleton.sharedInstance.serviceLogo != nil {
            self.imgDetailLogo.image = Singleton.sharedInstance.serviceLogo
        } else {
            if let imgUrl = category?.cat_image_url {
                let url = NSURL(string: imgUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imgDetailLogo.image = image
                        })
                    }
                    
                }).resume()
            }
        }
        self.vwCarouCell.alpha = 0
        self.vwBottom.alpha = 0
        self.vwServiceInfo.alpha = 0
        self.vwDetail.alpha = 1
    }
    func buildDetailView() {
        
        let scProductHeight = self.scDetailItems.frame.size.height
        var servArray = [ServiceItem]()
        if isClinic == true {
            servArray = services
        } else {
            servArray = filteredService
        }
        for i in 0  ..< servArray.count  {
            let service = servArray[i]
            let vwCell = UIView(frame: CGRectMake(scProductHeight*CGFloat(i), 0, scProductHeight, scProductHeight))
            let imgCell = UIImageView(frame: CGRectMake(0, 0, scProductHeight, scProductHeight))
            if let img_url = service.imageUrl as? String {
                let url = NSURL(string: img_url)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        if let image = UIImage(data : data!) {
                            dispatch_async(dispatch_get_main_queue(), {
                                imgCell.image = image
                            })
                        }
//                        let image : UIImage = UIImage(data: data!)!;
                        
                    }
                    
                }).resume()
            }
            vwCell.addSubview(imgCell)
            self.scDetailItems.addSubview(vwCell)
        }
        self.scDetailItems.contentSize = CGSize(width: scProductHeight * CGFloat(servArray.count), height: scProductHeight)
//        self.scDetailItems.contentSize = CGSizeMake(self.scDetailItems.frame.size.width, scHeight)
        
        isDetailLoad = true
        
    }
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        if isClinic == true {
            return services.count
        } else {
            return filteredService.count
        }
        
    }
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        let index = carousel.currentItemIndex
        print("iCarousel Index = \(index)")
        if isClinic == true {
            if index >= 0 && index < services.count  {
                currentSelectedIndex = index
                self.currentSelectedService = self.services[index]
                Singleton.sharedInstance.currentRequestedService = self.currentSelectedService
            }
        } else {
            if index >= 0 && index < filteredService.count  {
                currentSelectedIndex = index
                self.currentSelectedService = self.filteredService[index]
                Singleton.sharedInstance.currentRequestedService = self.currentSelectedService
            }
        }
        
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRectMake(10, 10, self.vwCarouCell.frame.size.height * 0.5, self.vwCarouCell.frame.size.height * 0.5))
        tempView.backgroundColor = UIColor.whiteColor()
        var servArary = [ServiceItem]()
        if isClinic == true {
            servArary = services
        } else {
            servArary = filteredService
        }
        if let item = servArary[index] as? ServiceItem {
            let tmWidth = tempView.frame.size.width
            let tmHeight = tempView.frame.size.height
            let imgVw = UIImageView(frame: CGRectMake(tmWidth / 6, tmWidth / 6, tmWidth * 2 / 3, tmWidth * 2 / 3))
            let button = UIButton(frame: CGRectMake(tempView.frame.size.width - 30, -20, 50, 50))
            let lblPrice = UILabel(frame: CGRectMake(0, tmWidth * 2 / 3 + 8, tmWidth, tmHeight - tmWidth * 2 / 3 - 8 ))
            lblPrice.textColor = UIColor(red: 0, green: 42 / 255, blue: 79 / 255, alpha: 1)
//            lblPrice.font = UIFont.systemFontOfSize(25)
            lblPrice.font = UIFont(name: "GoldenSans-Light", size: 25)
            lblPrice.textAlignment = .Center
            let lblText = "$ " + item.price!
            lblPrice.text = lblText
            
            button.tag = index
            button.setImage(UIImage(named: "info_button"), forState: .Normal)
            button.addTarget(self, action: #selector(ServiceVC.showServiceDetail(_:)), forControlEvents: .TouchUpInside)
            let url = NSURL(string: item.imageUrl)
            NSLog("ImageURL = \(item.imageUrl)")
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if data != nil && error == nil {
                    if let image = UIImage(data: data!) {
                        NSLog("Image Load Done!")
                        dispatch_async(dispatch_get_main_queue(), {
                            imgVw.image = image
                        })
                    }
//                    let image : UIImage = UIImage(data: data!)!;
                    
                }
                
            }).resume()
            tempView.addSubview(imgVw)
            tempView.addSubview(button)
            tempView.addSubview(lblPrice)
        }
        return tempView
    }
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value * 1.1
        }
        return value
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let destination = segue.destinationViewController as? LobbyRequestConfirmVC {
//            
//        }
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
