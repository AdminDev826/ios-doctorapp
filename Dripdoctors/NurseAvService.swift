//
//  NurseAvService.swift
//  Dripdoctors
//
//  Created by mac on 8/18/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class NurseAvService: NSObject {
    var id = ""
    var nurseId = ""
    var servId = ""
    var isAvailable : Bool?
    var approvedById = ""
    
    init(_id : String, _nurseId : String, _servId : String, _isAvailable : Bool, _approvedById : String) {
        self.id = _id
        self.nurseId = _nurseId
        self.servId = _servId
        self.isAvailable = _isAvailable
        self.approvedById = _approvedById
    }
}
