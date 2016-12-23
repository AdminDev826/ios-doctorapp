//
//  Singleton.swift
//  Dripdoctors
//
//  Created by mac on 7/29/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

enum ClientMode {
    case Service
    case FindNurse
    case Booking
    case Account
}
let sharedManager : Singleton = Singleton()
class Singleton: NSObject {
    var userSignUpFlag = false
    var userLoggedInFlag = false
    var user : User!
    
    // Client Services Variables
    var clientMode : ClientMode = .Service
    var currentCategory : ServiceCategory!
    var currentServices = [ServiceItem]();
    var currentRequestedService : ServiceItem!
    var serviceLogo : UIImage?
    var serviceItemLogo : UIImage?
    var isClientClinic = true
    
    // Client Find Nurse Variables
    var nurseItems = [Nurse]()
    var currentSelectedNurse : Nurse!
    var currentSelectedNurseCategory : ServiceCategory!
    var currentSelectedNurseItem : ServiceItem!
    var currentSelectedNurseCategoryLogo : UIImage!
    var currentSelectedNurseProductLogo : UIImage!
    
    // Client Booking Variables
    var currentClientSelectedBookingItem : Booking?
    var currentCancelId = "1"
    var currentTrackingNurse : Nurse?
    
    override init() {
        super.init()
    }
    
    class var sharedInstance: Singleton {
        return sharedManager
    }
}
