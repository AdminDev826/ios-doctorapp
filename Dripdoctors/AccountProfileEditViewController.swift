//
//  AccountMainViewController.swift
//  Dripdoctors
//
//  Created by Ruslan Podolsky on 31/08/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import DownPicker

protocol AccountProfileEditViewControllerDelegate {
    func saveProfileDelegate(user:User)
}

class AccountProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user = Singleton.sharedInstance.user
    let apiManager = APIManager.sharedManager

    let imagePicker = UIImagePickerController()
    let datePickerView:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    var delegate:AccountProfileEditViewControllerDelegate!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var imgSuperView: UIView!
    
    var genderDownPicker : DownPicker!
    var imgChangeFlag = true
    var tmpDateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        initView()
        loadData()
    }
    
    @IBAction func showDatePickerAction(sender: UITextField) {
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(AccountProfileEditViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(AccountProfileEditViewController.cancelPicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        if(user.birthDate != nil){
            datePickerView.setDate(user.birthDate!, animated: false)
        }
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(AccountProfileEditViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    @IBAction func textFieldEditing(sender: UITextField) {
        
    }
    
    func donePicker(){
        datePickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        txtAge.endEditing(true)
    }
    func cancelPicker(){
        txtAge.text = tmpDateString
        datePickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        txtAge.endEditing(true)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        txtAge.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func initView(){
        imgSuperView.layer.shadowColor = UIColor.blackColor().CGColor
    
        imgSuperView.layer.shadowOffset = CGSizeZero
        imgSuperView.layer.shadowOpacity = 1
        imgSuperView.layer.shadowRadius = 10
        
        imgSuperView.layer.cornerRadius = 5.0
        imgSuperView.clipsToBounds = true
        txtFirstName.layer.cornerRadius = 5.0
        txtFirstName.clipsToBounds = true
        txtLastName.layer.cornerRadius = 5.0
        txtLastName.clipsToBounds = true
        txtPhoneNumber.layer.cornerRadius = 5.0
        txtPhoneNumber.clipsToBounds = true
        txtCountry.layer.cornerRadius = 5.0
        txtCountry.clipsToBounds = true
        txtCity.layer.cornerRadius = 5.0
        txtCity.clipsToBounds = true
        txtAddress.layer.cornerRadius = 5.0
        txtAddress.clipsToBounds = true
        txtZip.layer.cornerRadius = 5.0
        txtZip.clipsToBounds = true
        txtGender.layer.cornerRadius = 5.0
        txtGender.clipsToBounds = true
        txtAge.layer.cornerRadius = 5.0
        txtAge.clipsToBounds = true
        
        let genders : NSMutableArray = ["Male", "Female"]
        self.genderDownPicker = DownPicker(textField: self.txtGender, withData: genders as [AnyObject])
    }
    
    func loadData(){
        txtFirstName.text = user.firstName!
        txtLastName.text = user.lastName!
        txtZip.text = user.zipCode!
        txtCity.text = user.city!
        txtGender.text = user.gender! == "M" ? "Male" : "Female"
        txtAddress.text = user.address!
        txtState.text = user.state!
        txtCountry.text = user.country!
//        if user.age != nil{
//            txtAge.text = String(user.age)
//        }
        if user.birthDate != nil {
            tmpDateString = Functions.getStringfromDate(user.birthDate!)
            txtAge.text = tmpDateString
        }
        if user.profileImage != nil{
            imgProfile.image = user.profileImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imgProfile.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgChangeFlag = true
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        imgProfile.image = nil
    }

    @IBAction func cameraAction(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func uploadAction(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.modalPresentationStyle = .Popover
        presentViewController(imagePicker, animated: true, completion: nil)
        imagePicker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
    }
    
    @IBAction func backAction(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if txtFirstName.text == "" {
            showAlert("Error",message: "Input the first name please!")
        }else if txtLastName.text == "" {
            showAlert("Error",message: "Input the last name please!")
        }else if txtPhoneNumber.text == "" {
            showAlert("Error",message: "Input the phone number please!")
        }else if txtCountry.text == "" {
            showAlert("Error",message: "Input the Country name please!")
        }else if txtState.text == "" {
            showAlert("Error",message: "Input the State name please!")
        }else if txtCity.text == "" {
            showAlert("Error",message: "Input the City name please!")
        }else if txtAddress.text == "" {
            showAlert("Error",message: "Input the Address please!")
        }else if txtZip.text == "" {
            showAlert("Error",message: "Input the zip code please!")
        }else if txtAge.text == "" {
            showAlert("Error",message: "Input the age please!")
        }else if imgProfile.image == nil {
            showAlert("Error",message: "Input the photo please!")
        }else {
            apiManager.updateUserInfo(user.id!, email: user.email!, fname: txtFirstName.text!, sname: txtLastName.text!, mobilenum: txtPhoneNumber.text!, address: txtAddress.text!, city: txtCity.text!, zip: txtZip.text!, state: user.state!, country: txtCountry.text!, gender: txtGender.text!, date_of_birth: "1979-07-04", imageUpdate: self.imgChangeFlag, image: imgProfile.image!, completionHandler: { (success, message) in
                if success == true {
                    NSLog("success");
                    dispatch_async(dispatch_get_main_queue(), {
                        Singleton.sharedInstance.user.firstName = self.txtFirstName.text!
                        Singleton.sharedInstance.user.lastName = self.txtLastName.text!
                        Singleton.sharedInstance.user.phoneNumber = self.txtPhoneNumber.text!
                        Singleton.sharedInstance.user.address = self.txtAddress.text!
                        Singleton.sharedInstance.user.city = self.txtCity.text!
                        Singleton.sharedInstance.user.zipCode = self.txtZip.text!
                        Singleton.sharedInstance.user.state = self.txtState.text!
                        Singleton.sharedInstance.user.country = self.txtCountry.text!
                        Singleton.sharedInstance.user.gender = self.txtGender.text!
                        
                        self.delegate.saveProfileDelegate(Singleton.sharedInstance.user)
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    })
                }else {
                    NSLog("failed")
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showAlert("Error", message: "Server Error")
                    })
                }
            })
        }
    }
    
    func showAlert(title: String, message : String){
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
    }
}
