//
//  NurseRequestVC.swift
//  Dripdoctors
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class NurseRequestVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var vwServiceInfo: UIView!
    @IBOutlet weak var imgServiceLogo: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblServicePrice: UILabel!
    @IBOutlet weak var vwDateTime: UIView!
    @IBOutlet weak var scDateTime: UIScrollView!
    @IBOutlet weak var imgCheckUserLocation: UIImageView!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var imgCheckSpecificLocation: UIImageView!
    @IBOutlet weak var lblSpecificLocation: UILabel!
    @IBOutlet weak var txtSpecificAddress: UITextField!
    @IBOutlet weak var imgCheckSoonable: UIImageView!
    @IBOutlet weak var imgCheckSpecificTime: UIImageView!
    @IBOutlet weak var lblSpecificTime: UILabel!
    @IBOutlet weak var pickerSpecificDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
