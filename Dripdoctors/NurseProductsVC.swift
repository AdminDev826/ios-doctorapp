//
//  NurseProductsVC.swift
//  Dripdoctors
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class NurseProductsVC: UIViewController,iCarouselDelegate, iCarouselDataSource,UIScrollViewDelegate {

    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var vwServiceInfo: UIView!
    @IBOutlet weak var imgServiceLogo: UIImageView!
    @IBOutlet weak var lblPrdChoose: UILabel!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var vwCarouSel: UIView!
    @IBOutlet weak var carouSel: iCarousel!
    @IBOutlet weak var scServiceDetail: UIScrollView!
    @IBOutlet weak var lblDetailSerName: UILabel!
    @IBOutlet weak var txtDetailServDes: UITextView!
    @IBOutlet weak var imgDetailServLogo: UIImageView!
    @IBOutlet weak var txtDetailMobDes: UITextView!
    @IBOutlet weak var scDetailServList: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return 0
    }
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
//        let index = carousel.currentItemIndex
//        print("iCarousel Index = \(index)")
//        if index >= 0 && index < services.count  {
//            currentSelectedIndex = index
//            self.currentSelectedService = self.services[index]
//        }
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRectMake(10, 10, self.vwCarouSel.frame.size.height * 0.8, self.vwCarouSel.frame.size.height * 0.8))
//        tempView.backgroundColor = UIColor.whiteColor()
//        if let item = services[index] as? ServiceItem {
//            let imgVw = UIImageView(frame: CGRectMake(0, 0, tempView.frame.size.width, tempView.frame.size.height))
//            let button = UIButton(frame: CGRectMake(tempView.frame.size.width - 50, 0, 50, 50))
//            button.tag = index
//            button.setImage(UIImage(named: "info_button"), forState: .Normal)
//            button.addTarget(self, action: #selector(ServiceVC.showServiceDetail(_:)), forControlEvents: .TouchUpInside)
//            let url = NSURL(string: item.imageUrl)
//            NSLog("ImageURL = \(item.imageUrl)")
//            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//                if data != nil && error == nil {
//                    let image : UIImage = UIImage(data: data!)!;
//                    NSLog("Image Load Done!")
//                    dispatch_async(dispatch_get_main_queue(), {
//                        imgVw.image = image
//                    })
//                }
//                
//            }).resume()
//            tempView.addSubview(imgVw)
//            tempView.addSubview(button)
//        }
        return tempView
    }
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value * 1.1
        }
        return value
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
