//
//  AccountEditViewController.swift
//  Dripdoctors
//
//  Created by Ruslan Podolsky on 01/09/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

protocol AccountEditViewControllerDelegate {
    func passwordSaveDelegate(usr: User)
}

class AccountEditViewController: UIViewController {

    var user = Singleton.sharedInstance.user
    let apiManager = APIManager.sharedManager
    var delegate:AccountEditViewControllerDelegate!
    
    @IBOutlet weak var txtNewConfirm: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        loadData()
        
    }
    
    func initView(){
        txtEmail.layer.cornerRadius = 5.0
        txtEmail.clipsToBounds = true
        txtOldPassword.layer.cornerRadius = 5.0
        txtOldPassword.clipsToBounds = true
        txtNewPassword.layer.cornerRadius = 5.0
        txtNewPassword.clipsToBounds = true
        txtNewConfirm.layer.cornerRadius = 5.0
        txtNewConfirm.clipsToBounds = true
        
    }
    func loadData(){
        txtEmail.text = user.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func saveAction(sender: AnyObject) {
        
        if txtEmail.text == "" {
            showAlertView("Error?", message: "Input the Email please!")
            return
        }
        if !Functions.isValidEmail(txtEmail.text!) {
            showAlertView("Error?", message: "Input the Email correctly!")
            return
        }
        if txtOldPassword.text == "" {
            showAlertView("Error?", message: "Input the actual password please!")
            return
        }
        if txtNewPassword.text == "" {
            showAlertView("Error?", message: "Input the new password please!")
            return
        }
        if txtNewConfirm.text == "" {
            showAlertView("Error?", message: "Input the confirm password please!")
            return
        }
        if txtNewPassword.text != txtNewConfirm.text {
            showAlertView("Error?", message: "Input the confirm password correctly!")
            return
        }
        
        apiManager.updateUserPassword(user.id!, userName: txtEmail.text!, newPassword: txtNewPassword.text!, newPasswordConfirm: txtNewConfirm.text!, actualPassword: user.password!, completionHandler: { (success, message) in
            if success == true {
                NSLog("success");
                dispatch_async(dispatch_get_main_queue(), {
                    Singleton.sharedInstance.user.password = self.txtNewPassword.text!
                    Singleton.sharedInstance.user.email = self.txtEmail.text!
                    
                    self.delegate.passwordSaveDelegate(Singleton.sharedInstance.user)
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }else {
                NSLog("failed")
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlertView("Error?", message: "Server Error")
                })
            }
        })
    }
    func showAlertView(title : String, message : String){
        let atitle = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont(name: "GothamPro-Medium", size: 15)!])
        let amessage = NSAttributedString(string: message, attributes: [
            NSFontAttributeName : UIFont(name: "GoldenSans-Light", size: 12)!])
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        
        alert.setValue(atitle, forKey: "attributedTitle")
        alert.setValue(amessage, forKey: "attributedMessage")
        
        self.presentViewController(alert, animated: true, completion: nil)
    }}
