//
//  NormalAnnotation.swift
//  Dripdoctors
//
//  Created by mac on 8/12/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import MapKit

class NormalAnnotation: MKPointAnnotation {
    var index : Int?
    
    init(index : Int) {
        self.index = index
    }
    
}
