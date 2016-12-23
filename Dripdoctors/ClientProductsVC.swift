//
//  ClientProductsVC.swift
//  Dripdoctors
//
//  Created by mac on 8/7/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ClientProductsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwClinic: UIView!
    @IBOutlet weak var vwHouseCall: UIView!
    @IBOutlet weak var imgServiceLogo: UIImageView!
    @IBOutlet weak var lblDetailTitle: UILabel!
//    @IBOutlet weak var scProducts: UIScrollView!
    @IBOutlet weak var collectionVW: UICollectionView!
    
    var selectedVW : UIView!
    let uiManager = UIManager.sharedManager
    var selectedProduct : ServiceItem!
    var deviseSize : CGSize?
    var scSize = CGSizeMake(320, 180)
    var firstSelectedIndex : NSInteger!
    var currentIndexPath : NSIndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        deviseSize = UIScreen.mainScreen().bounds.size
        scSize = self.collectionVW.frame.size
        
        update()
        self.collectionVW.reloadData()
    }
    func update() {
        if (Singleton.sharedInstance.currentCategory != nil) {
            self.lblTitle.text = Singleton.sharedInstance.currentCategory.category_name
            self.lblDetailTitle.text = Singleton.sharedInstance.currentCategory.category_name
            if Singleton.sharedInstance.serviceLogo != nil {
                imgServiceLogo.image = Singleton.sharedInstance.serviceLogo
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
            if Singleton.sharedInstance.currentCategory?.inhouse_call == true {
                self.vwHouseCall.backgroundColor = uiManager.selected_color
                self.vwClinic.backgroundColor = uiManager.normal_color
                
            } else {
                self.vwHouseCall.backgroundColor = uiManager.normal_color
                self.vwClinic.backgroundColor = uiManager.selected_color
                
            }
        }
        
    }
    //Not using now.
    func loadProducts() {
        let cellWidth = scSize.width / 4
        let cellHeight = cellWidth + 30
        if Singleton.sharedInstance.currentServices.count > 0 {
            for i in 0 ..< Singleton.sharedInstance.currentServices.count {
                let item = Singleton.sharedInstance.currentServices[i]
                let row_index = i / 4
                let column_index = i % 4
                let vwCell = UIView(frame: CGRectMake(cellWidth * CGFloat(column_index), cellHeight * CGFloat(row_index), cellWidth, cellHeight))
                let imgCell = UIImageView(frame: CGRectMake(5, 5, cellWidth - 10, cellWidth - 10))
                let strImgUrl = item.imageUrl
                let url = NSURL(string: strImgUrl)
                NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                    if data != nil && error == nil {
                        let image : UIImage = UIImage(data: data!)!;
                        dispatch_async(dispatch_get_main_queue(), {
                            imgCell.image = image
                        })
                    }
                    
                }).resume()
                let lblCell = UILabel(frame: CGRectMake(0, cellWidth, cellWidth, 30))
                lblCell.text = "$ \(item.price)"
                lblCell.textColor = UIColor.blueColor()
                lblCell.textAlignment = .Center
//                lblCell.font = UIFont.systemFontOfSize(12)
                lblCell.font = UIFont(name: "GothamPro-Light", size: 12)
                
                let btnCell = UIButton(frame: CGRectMake(0, 0, cellWidth, cellHeight))
                btnCell.tag = i
//                btnCell.addTarget(self, action: "", forControlEvents: .TouchUpInside)
                
                vwCell.addSubview(imgCell)
                vwCell.addSubview(lblCell)
                vwCell.addSubview(btnCell)
                
//                self.scProducts.addSubview(vwCell)
                
            }
        }
    }
    func selectProduct() {
        
    }
    
    @IBAction func actionServices(sender: AnyObject) {
        self.performSegueWithIdentifier("showServices", sender: nil)
    }
    @IBAction func actionInformation(sender: AnyObject) {
    }
    @IBAction func actionNext(sender: AnyObject) {
        if selectedProduct != nil {
            Singleton.sharedInstance.currentRequestedService = selectedProduct
        }
        self.performSegueWithIdentifier("showBookingRequestVC", sender: nil)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProductCell
        let item = Singleton.sharedInstance.currentServices[indexPath.row]
        cell.lblPrice.text = "$ " + item.price!
        let strImgUrl = item.imageUrl
        let url = NSURL(string: strImgUrl)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if data != nil && error == nil {
                let image : UIImage = UIImage(data: data!)!;
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imgProduct.image = image
                })
            }
            
        }).resume()
        if currentIndexPath != nil && currentIndexPath == indexPath {
            cell.vwProduct.backgroundColor = uiManager.normal_color
            cell.lblPrice.textColor = UIColor.whiteColor()
        }
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        return CGSizeMake(scSize.width / 4, scSize.width / 4 + 5)
//    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Singleton.sharedInstance.currentServices.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("did select")
        if currentIndexPath != nil {
            let lastCell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? ProductCell
            lastCell?.vwProduct.backgroundColor = UIColor.whiteColor()
            lastCell?.lblPrice.textColor = UIColor.blackColor()
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ProductCell
        cell?.vwProduct.backgroundColor = uiManager.normal_color
        cell?.lblPrice.textColor = UIColor.whiteColor()
        currentIndexPath = indexPath
        selectedProduct = Singleton.sharedInstance.currentServices[indexPath.row]
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
