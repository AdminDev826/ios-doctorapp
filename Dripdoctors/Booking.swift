//
//  Booking.swift
//  Dripdoctors
//
//  Created by mac on 8/17/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class Booking: NSObject {
    var userId = ""
    var bookingId = ""
    var bookingType : Bool?
    var isGPS : Bool?
    var gps_latitude : Double?
    var gps_longitude : Double?
    var client_address = ""
    var clinicId = ""
    var timeType : Bool?
    var booking_date = ""
    var booking_time = ""
    var servId = ""
    var transCode = ""
    var transType = ""
    var processId : Int?
    var status : Int?
    var cancelled : Int?
    var nurseIdAssigned : Bool?
    var reviewRate = ""
    var createdDate : NSDate?
    var bookingdateTime : NSDate?
    var productInfo : ServiceItem?
    var isEmptyProd = false
    var isEmptyService = false
    var serviceInfo : ServiceCategory?
    
    var nurseId : String?
    
    var nurseInfo : Nurse?
    var clinicInfo : Clinic?
    
    init(bookingId : String, userId : String, isGPS : Bool, bookingType : Bool, latitude : Double, longitude: Double, address : String, cliendId : String, timeType : Bool, booking_date : String, booking_time : String, servId : String, transCode : String, transType : String, proc_id : Int, status: Int, cancel : Int, isNurseAssigned : Bool, reviewRate : String, createdDate : NSDate, nurseId : String, _clinicInfo : Clinic, _nurseInfo : Nurse, _servCategory : ServiceCategory, _prodInfo: ServiceItem, _isemptyProd : Bool, _isemptyServ : Bool) {
        self.bookingId = bookingId
        self.bookingType = bookingType
        self.userId = userId
        self.isGPS = isGPS
        self.gps_latitude = latitude
        self.gps_longitude = longitude
        self.client_address = address
        self.clinicId = cliendId
        self.timeType = timeType
        self.booking_date = booking_date
        self.booking_time = booking_time
        self.servId = servId
        self.transCode = transCode
        self.transType = transType
        self.processId = proc_id
        self.status = status
        self.cancelled = cancel
        self.nurseIdAssigned = isNurseAssigned
        self.reviewRate = reviewRate
        self.createdDate = createdDate
        self.nurseId = nurseId
        self.clinicInfo = _clinicInfo
        self.nurseInfo = _nurseInfo
        if _isemptyProd == true {
            self.isEmptyProd = _isemptyProd
            self.productInfo = _prodInfo
        }
        if _isemptyServ {
            self.isEmptyService = _isemptyServ
            self.serviceInfo = _servCategory
        }
        
        if booking_date.characters.count > 0 && booking_time.characters.count > 0 {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = booking_date + " " + booking_time
            print("Booking Date Time String =\(dateString)")
            self.bookingdateTime = dateFormat.dateFromString(dateString)
        }
        
    }
}
