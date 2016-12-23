//
//  Functions.swift
//  Dripdoctors
//
//  Created by Ruslan Podolsky on 02/09/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class Functions{
    class func getImageData(image: UIImage) -> String{
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let strBase64: String =  (imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))!
        return strBase64
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    class func getStringfromDate(date: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
    }
    class func getDateFromString(date: String) -> NSDate{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.dateFromString(date)
        return dateObj!
    }
}
