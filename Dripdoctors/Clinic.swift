//
//  Clinic.swift
//  Dripdoctors
//
//  Created by mac on 8/9/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class Clinic: NSObject {
    var id = ""
    var name = ""
    var address = ""
    var zipcode = ""
    var city = ""
    var state = ""
    var managerId = ""
    var latitude = ""
    var longitude = ""
    init(id : String, name : String, address : String, zipCode : String, city : String, state : String, managerId : String, lat : String, long : String) {
        self.id = id
        self.name = name
        self.address = address
        self.zipcode = zipCode
        self.city = city
        self.state = state
        self.managerId = managerId
        self.latitude = lat
        self.longitude = long
    }
}
