//
//  Nurse.swift
//  Dripdoctors
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class Nurse: NSObject {
    var id = ""
    var online = false
    var active = false
    var longitude : Double?
    var latitude : Double?
    var date : NSDate?
    var imgUrl : String?
    var firstName = ""
    var lastName = ""
    var services = [NurseAvService]()
    var review = ""
    var score : Double?
    
    init(id : String, online : Bool, active : Bool, long : Double, lat : Double, date : NSDate, url : String, firstName : String, lastName : String, review : String, score : Double, servs : [NurseAvService]) {
        self.id = id
        self.online = online
        self.active = active
        self.longitude = long
        self.latitude = lat
        self.date = date
        self.imgUrl = url
        self.firstName = firstName
        self.lastName = lastName
        self.review = review
        self.score = score
        self.services = servs
    }
}
