//
//  ServiceItem.swift
//  Dripdoctors
//
//  Created by mac on 8/2/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ServiceItem: NSObject {
    var serviceId = ""
    var serviceName = ""
    var categoryId = ""
    var servicedescription = ""
    var price : String?
    var inhouseCall : Bool?
    var imageUrl = ""
    var mobiledescription = ""
    var discount : String?
    var fee : String?
    init(servId : String, name: String,catId: String, servDes : String, price : String, inHouseCall : Bool, imgUrl : String, mobDes : String, discount : String, fee : String) {
        self.serviceId = servId
        self.serviceName = name
        self.categoryId = catId
        self.servicedescription = servDes
        self.price = price
        self.inhouseCall = inHouseCall
        self.imageUrl = imgUrl
        self.mobiledescription = mobDes
        self.discount = discount
        self.fee = fee
        super.init()
    }
}
