//
//  User.swift
//  Dripdoctors
//
//  Created by mac on 7/30/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : String?
    var firstName : String?
    var lastName : String?
    var email : String?
    var zipCode : String?
    var phoneNumber : String?
    var country : String?
    var state : String?
    var city : String?
    var address : String?
    var password : String?
    var gender : String?
    var age : Int?
    var active_flag : Bool?
    var status_flag : Int?
    var birthDate : NSDate?
    var userGroup : Int?
    var message : String?
    var imgURL : String?
    
    var profileImage : UIImage?
    
    init(email : String){
        self.firstName = ""
        self.lastName = ""
        self.email = email
        self.gender = ""
    }    
}
