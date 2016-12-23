//
//  NurseServiceVC.swift
//  Dripdoctors
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class NurseServiceVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var lblNurseName: UILabel!
    @IBOutlet weak var scServList: UIScrollView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var vwTitle: UIView!
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
