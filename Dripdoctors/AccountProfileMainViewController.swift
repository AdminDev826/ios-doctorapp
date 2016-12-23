//
//  AccountProfileViewController.swift
//  Dripdoctors
//
//  Created by Ruslan Podolsky on 31/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class AccountProfileMainViewController: UIViewController, AccountProfileEditViewControllerDelegate {
    
    @IBOutlet weak var btnDrip: UIButton!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblAdress: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var imgUserImage: UIImageView!
    @IBOutlet weak var imgSuperView: UIView!
    @IBOutlet weak var vwToolbarTop: NSLayoutConstraint!
    
    
    let def_min_constant : CGFloat = 35
    let def_max_constant : CGFloat = 85
    
    var isDrop : Bool? {
        didSet {
            self.showToolBar()
        }
    }
    var user = Singleton.sharedInstance.user

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isDrop = true
        initView()
        loadData(self.user)
    }

    func initView(){
        imgSuperView.layer.shadowColor = UIColor.blackColor().CGColor
        imgSuperView.layer.shadowOffset = CGSizeZero
        imgSuperView.layer.shadowOpacity = 1
        imgSuperView.layer.shadowRadius = 10
        
        imgSuperView.layer.cornerRadius = 5.0
        imgSuperView.clipsToBounds = true
    }
    
    func loadData(usr:User){
        lblName.text = usr.firstName! + " " + usr.lastName!
        lblSex.text = usr.gender!
        lblZip.text = usr.zipCode!
        lblCity.text = usr.city!
        lblPhone.text = usr.phoneNumber!
        lblAdress.text = usr.address!
        lblCountry.text = usr.country!
//        if user.age != nil{
//            lblAge.text = String(usr.age)
//        }
        if let image = usr.profileImage{
            imgUserImage.image = image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @IBAction func actionDrip(sender: AnyObject) {
        if isDrop == false {
            self.btnDrip.setBackgroundImage(UIImage(named: "drip_off"), forState: .Normal)
            isDrop = true
        } else {
            self.btnDrip.setBackgroundImage(UIImage(named: "drip_on"), forState: .Normal)
            isDrop = false
        }
    }
    @IBAction func actionAccount(sender: AnyObject) {
        
    }
    @IBAction func actionPayments(sender: AnyObject) {
        
    }
    
    func saveProfileDelegate(user:User) {
        print("AccountProfileEditViewControllerDelegate")
        loadData(user)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destinationViewController as! AccountProfileEditViewController
            vc.delegate = self
            
        }
    }
}
