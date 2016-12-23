//
//  AccountPaymentsViewController.swift
//  Dripdoctors
//
//  Created by Ruslan Podolsky on 31/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class AccountMainViewController: UIViewController, AccountEditViewControllerDelegate {

    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var btnDrip: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var toolbarTop: NSLayoutConstraint!
    
    
    let def_min_constant : CGFloat = 35
    let def_max_constant : CGFloat = 85
    
    var isDrop : Bool? {
        didSet {
            self.showToolBar()
        }
    }
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isDrop = true
        initView();
        user = Singleton.sharedInstance.user
        loadData(user)
    }
    
    func initView(){
        emailView.layer.shadowColor = UIColor.blackColor().CGColor
        emailView.layer.shadowOffset = CGSizeZero
        emailView.layer.shadowOpacity = 0.8
        emailView.layer.shadowRadius = 10
        lblEmail.layer.cornerRadius = 5.0
        lblEmail.clipsToBounds = true
        
        passwordView.layer.shadowColor = UIColor.blackColor().CGColor
        passwordView.layer.shadowOffset = CGSizeZero
        passwordView.layer.shadowOpacity = 0.8
        passwordView.layer.shadowRadius = 10
        lblPassword.layer.cornerRadius = 5.0
        lblPassword.clipsToBounds = true
        
    }
    
    func loadData(usr: User){
        lblEmail.text = usr.email
    }
    
    func showToolBar(){
        if isDrop == true {
            toolbarTop.constant = def_max_constant
            self.vwMenu.alpha = 1
        } else {
            toolbarTop.constant = def_min_constant
            self.vwMenu.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dripAction(sender: AnyObject) {
        if isDrop == false {
            self.btnDrip.setBackgroundImage(UIImage(named: "drip_off"), forState: .Normal)
            isDrop = true
        } else {
            self.btnDrip.setBackgroundImage(UIImage(named: "drip_on"), forState: .Normal)
            isDrop = false
        }
    }
    func passwordSaveDelegate(usr: User) {
        loadData(usr)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPasswordSegue" {
            let vc = segue.destinationViewController as! AccountEditViewController
            vc.delegate = self
            
        }
    }
    
}
