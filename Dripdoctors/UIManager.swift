//
//  UIManager.swift
//  Dripdoctors
//
//  Created by mac on 8/3/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class UIManager: NSObject {
    static let sharedManager = UIManager()
    let normal_color = UIColor(colorLiteralRed: 0, green: 0.2471, blue: 0.3529, alpha: 1)
    let editbar_color = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
    let black_color = UIColor.blackColor()
    let selected_color = UIColor(colorLiteralRed: 0, green: 0.7137, blue: 0.9255, alpha: 1)
    let drip_off_image = UIImage(named: "drip_off")
    let drip_on_image = UIImage(named: "drip_on")
    let check_image = UIImage(named: "check_button")
    let uncheck_image = UIImage(named: "uncheck_button")
}
