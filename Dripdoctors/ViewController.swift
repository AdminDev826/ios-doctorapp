//
//  ViewController.swift
//  Dripdoctors
//
//  Created by mac on 7/18/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let apiManager = APIManager.sharedManager
    let textValidationManager = TextFieldValidationsManager()
    let reachabilityHander = ReachabilityHandler()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.text = "digitalmaster909@hotmail.com"
        txtPassword.text = "dripdoctors"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSignIn(sender: UIButton) {
        let emailFieldState = textValidationManager.isValidEmail(txtEmail.text!)
        let emailString = txtEmail.text
        let passwordString = txtPassword.text
        
        if emailFieldState == true {
            apiManager.logIn(emailString!, pwd: passwordString!, completionHandler: { (success, message) in
                if success == true {
                    NSLog("success");
                    dispatch_async(dispatch_get_main_queue(), { 
//                        self.userProgress()
                        UserLocationManager.sharedManager.startManager()
                        self.testFunc()
                    })
                } else {
                    NSLog("failed")
                    dispatch_async(dispatch_get_main_queue(), {
                        //                        self.userProgress()
                        self.setEditing(false, animated: false)
                        let alert = self.showAlertView("Error?", message: "Email or Password was wrong. Please try again.")
                        self.presentViewController(alert, animated: false, completion: nil)
//                        self.testFunc()
//                        UserLocationManager.sharedManager.startManager()
                    })
                }
            })
        }
    }
    @IBAction func actionSignUp(sender: UIButton) {
        performSegueWithIdentifier("showRegisterVC", sender: nil)
    }
    @IBAction func actionResetPassword(sender: UIButton) {
        performSegueWithIdentifier("showResetVC", sender: nil)
    }
    func userProgress() {
        let title = "Error?"
        let message = Singleton.sharedInstance.user.message
        let user = Singleton.sharedInstance.user
        if user.active_flag == true && user.status_flag == 1 {
            gotoDashboard()
        } else {
            let alert = showAlertView(title, message: message!)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func gotoDashboard() {
        if Singleton.sharedInstance.user.userGroup == 1 {
            appDelegate.showAdminStoryboard(false)
        } else if Singleton.sharedInstance.user.userGroup == 2 {
            let title = "Error?"
            let message = "Your account have some error."
            let alert = showAlertView(title, message: message)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if Singleton.sharedInstance.user.userGroup == 3 {
            appDelegate.showNurseStoryboard(false)
        } else if Singleton.sharedInstance.user.userGroup == 4 {
            appDelegate.showClientStoryboard(false)
        }
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
    func testFunc() {
        Singleton.sharedInstance.user.password = txtPassword.text!
        appDelegate.showClientStoryboard(false)
//        appDelegate.showNurseStoryboard(false)
    }
}
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}