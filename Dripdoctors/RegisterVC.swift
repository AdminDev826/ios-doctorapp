//
//  RegisterVC.swift
//  Dripdoctors
//
//  Created by mac on 7/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    let apiManager = APIManager.sharedManager
    let textValidationManager = TextFieldValidationsManager()
    let reachabilityHander = ReachabilityHandler()
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionSignUp(sender: UIButton) {
        let emailFieldState = textValidationManager.isValidEmail(txtEmail.text!)
        let emailString = txtEmail.text
        let passwordString = txtPassword.text
        if emailFieldState == true {
            apiManager.register(emailString!, pwd: passwordString!, completionHandler: { (success, message) in
                if success == true {
                    NSLog("success");
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.performSegueWithIdentifier("showValidationVC", sender: nil)
                    })
                } else {
                    NSLog("failed")
                }
            })
        }
    }
    @IBAction func actionSignIn(sender: UIButton) {
        performSegueWithIdentifier("showLogIn", sender: nil)
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
extension RegisterVC : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}