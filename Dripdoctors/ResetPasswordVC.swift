//
//  ResetPasswordVC.swift
//  Dripdoctors
//
//  Created by mac on 7/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    
    let apiManager = APIManager.sharedManager
    let textValidationManager = TextFieldValidationsManager()
    let reachabilityHander = ReachabilityHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionResetPassword(sender: AnyObject) {
        let emailFieldState = textValidationManager.isValidEmail(txtEmail.text!)
        let emailString = txtEmail.text
        if emailFieldState == true {
            apiManager.forgotpassword(emailString!, completionHandler: { (success, message) in
                if success == true {
                    NSLog("Success");
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.performSegueWithIdentifier("showConfirmVC", sender: nil)
                    })
                } else {
                    
                }
            })
        }
    }

    @IBAction func actionSignIn(sender: UIButton) {
        performSegueWithIdentifier("showLoginVC", sender: nil)
    }
    
    @IBAction func actionSignUp(sender: UIButton) {
        performSegueWithIdentifier("showRegisterVC", sender: nil)
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
extension ResetPasswordVC : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
