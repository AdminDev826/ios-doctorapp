//
//  ClientBookingEdittingVC.swift
//  Dripdoctors
//
//  Created by mac on 8/26/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ClientBookingEdittingVC: UIViewController {

    @IBOutlet weak var imgServLogo: UIImageView!
    @IBOutlet weak var lblServName: UILabel!
    @IBOutlet weak var lblProdName: UILabel!
    @IBOutlet weak var lblServEdited: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCallType: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    @IBOutlet weak var lblAddressEdited: UILabel!
    @IBOutlet weak var imgNursePhoto: UIImageView!
    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var imgReview1: UIImageView!
    @IBOutlet weak var imgReview2: UIImageView!
    @IBOutlet weak var imgReview3: UIImageView!
    @IBOutlet weak var imgReview4: UIImageView!
    @IBOutlet weak var imgReview5: UIImageView!
    @IBOutlet weak var lblNurseOverview: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func actionCancel(sender: AnyObject) {
        self.performSegueWithIdentifier("showBookingsVC", sender: nil)
    }
    @IBAction func actionUpdate(sender: AnyObject) {
        
    }
    @IBAction func actionServEdit(sender: AnyObject) {
    }
    @IBAction func actionAddressEdit(sender: AnyObject) {
    }
    @IBAction func actionNurseEdit(sender: AnyObject) {
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
