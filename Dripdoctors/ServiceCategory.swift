//
//  ServiceCategory.swift
//  Dripdoctors
//
//  Created by mac on 7/31/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ServiceCategory: NSObject {
    var category_id = ""
    var category_name = ""
    var category_description = ""
    var cat_image_url = ""
    var inhouse_call = false
    
    init(id : String, name : String, description : String, url : String, call : Bool) {
        self.category_id = id
        self.category_name = name
        self.category_description = description
        self.cat_image_url = url
        self.inhouse_call = call
        super.init()
    }
}
