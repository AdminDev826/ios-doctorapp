//
//  APIManager.swift
//  Dripdoctors
//
//  Created by mac on 7/28/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import Foundation
import CryptoSwift
import MapKit

let baseURL = "http://uapi.dripdoctors.com/"
let hashKey = "R0ule11eDarez"
class APIManager: NSObject {
    static let sharedManager = APIManager()
    
    private let failedURLMessage = "We can't access server's URL"
    let logInURL = baseURL + "login"
    let registerURL = baseURL + "register"
    let updateUserInfoURL = baseURL + "updateUserInfo"
    let updateUserPasswordURL = baseURL + "userUpdatePassword"
    let forgotpasswordURL = baseURL + "forgotPassword"
    
    let getCategoryURL = baseURL + "getCategories"
    let getCategoryItemURL = baseURL + "getServices"
    let getClinicURL = baseURL + "getClinics"
    let sendBookingRequestURL = baseURL + "sendBooking"
    let getNurseURL = baseURL + "getNurses"
    let getBookingURL = baseURL + "getAllBookings"
    
    let cancelBookingURL = baseURL + "cancelBooking"
    var cancelBookingTask : NSURLSessionUploadTask!
    
    let applyAgainURL = baseURL + "sendApplyBookingAgain"
    var applyAgainTask : NSURLSessionUploadTask!
    
    let sendMessageURL = baseURL + "sendMessageNurse"
    var sendMessagingTask : NSURLSessionUploadTask!
    
    let sendAskRefundURL = baseURL + "sendAskRefund"
    var sendAskRefundTask : NSURLSessionUploadTask!
    
    let sendReporseNurseURL = baseURL + "sendReportNurse"
    var sendReportNurseTask : NSURLSessionUploadTask!
    
    let sendRemoveBookingURL = baseURL + "sendRemoveBooking"
    var sendRemoveBookingTask : NSURLSessionUploadTask!
    
    let getAllNurseCallsURL = baseURL + "getAllNurseCalls"
    var getAllNurseCallTask : NSURLSessionUploadTask!
    
    let updateCallStatusURL = baseURL + "updateCallStatus"
    var updateCallStatusTask : NSURLSessionUploadTask!
    
    let sendNurseStatusURL = baseURL + "sendNurseStatus"
    var sendNurseStatusTask : NSURLSessionUploadTask!
    
    let sendNurseReviewURL = baseURL + "sendNurseReview"
    var sendNurseReviewTask : NSURLSessionUploadTask!
    
    let getNursePaymentsURL = baseURL + "getNursePayments"
    var getNursePaymentsTask : NSURLSessionUploadTask!
    
    let changeBookingTimeURL = baseURL + "changeBookingTime"
    var changeBookingTimeTask : NSURLSessionUploadTask!
    
    let getRefundPaymentURL = baseURL + "getResumePayment"
    var getRefundPaymentTask : NSURLSessionUploadTask!
    
    let getAllPaymentURL = baseURL + "getAllPayments"
    var getAllPaymentTask : NSURLSessionUploadTask!
    
    let getAllAdminDashboardURL = baseURL + "getAllAdminDashboard"
    var getAllAdminDashboardTask : NSURLSessionUploadTask!
    
    let sendNurseLocationURL = baseURL + "sendNurseLocation"
    var sendNurseLocationTask : NSURLSessionUploadTask!
    
    let getNurseLocationURL = baseURL + "getNurseLocation"
    var getNurseLocationTask : NSURLSessionUploadTask!
    
    var currentYear : Int = 2016
    var md5Key : String!
    var registerTask : NSURLSessionUploadTask!;
    var logInTask : NSURLSessionUploadTask!;
    var updateUserInfoTask : NSURLSessionUploadTask!
    var updateUserPasswordTask : NSURLSessionUploadTask!
    var getCategoryTask : NSURLSessionUploadTask!
    var getServiceItemTask : NSURLSessionUploadTask!
    var forgotPasswordTask : NSURLSessionUploadTask!
    var getClinicTask : NSURLSessionUploadTask!
    var sendBookingRequestTask : NSURLSessionUploadTask!
    var getNurseTask : NSURLSessionUploadTask!
    var getBookingTask : NSURLSessionUploadTask!
    
    override init() {
        super.init()
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        currentYear =  components.year
        let strKey = "\(hashKey)\(currentYear)"
        md5Key = generateMD5(strKey)
        NSLog("log")
        
    }
    func getNurseLocation(nurseId: String, closure: (success : Bool, location:NSDictionary, message : String?) -> Void){
        if let url = NSURL(string: getNurseLocationURL) {
            let queryString = "key=\(md5Key)&nurseId=\(nurseId)"
            self.getNurseLocationTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let locations = root["nurseLocation"] as? [NSDictionary]
                    if locations?.count > 0 {
                        let locItem = locations?.last
                         closure(success: success, location: locItem!, message: "")
                    } else {
                        closure(success: success, location: NSDictionary(), message: "")
                    }
                   
                } else {
                    closure(success: success, location: NSDictionary(), message: "AM failed to send message to nurse.")
                }
            });
            self.getNurseLocationTask.resume()
        }
    }
    func sendNurseLocation(nurseId :String, gpsLongitude : String, gpsLatitude: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendNurseLocationURL) {
            let queryString = "key=\(md5Key)&nurseId=\(nurseId)&gpsLongitud=\(gpsLongitude)&gpsLatitud=\(gpsLatitude)"
            self.sendNurseLocationTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendNurseLocationTask.resume()
        }
    }
    func getAllAdminDashboard(closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: getAllAdminDashboardURL) {
            let queryString = "key=\(md5Key)"
            self.getAllAdminDashboardTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.getAllAdminDashboardTask.resume()
        }
    }
    func getAllPayment(closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: getAllPaymentURL) {
            let queryString = "key=\(md5Key)"
            self.getAllPaymentTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.getAllPaymentTask.resume()
        }
    }
    func getResumePayment(closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: getRefundPaymentURL) {
            let queryString = "key=\(md5Key)"
            self.getRefundPaymentTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.getRefundPaymentTask.resume()
        }
    }
    func bookingChageTime(bookingId: String,dateTime: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: changeBookingTimeURL) {
            let queryString = "bookingId=\(bookingId)&dateTime=\(dateTime)&key=\(md5Key)"
            self.changeBookingTimeTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.changeBookingTimeTask.resume()
        }
    }
    func getNursePayments(nurseId: String,dateTime: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: getNursePaymentsURL) {
            let queryString = "nurseId=\(nurseId)&dateTime=\(dateTime)&key=\(md5Key)"
            self.getNursePaymentsTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.getNursePaymentsTask.resume()
        }
    }
    func sendNurseReview(nurseId: String,review: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendNurseReviewURL) {
            let queryString = "nurseId=\(nurseId)&review=\(review)&key=\(md5Key)"
            self.sendNurseReviewTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendNurseReviewTask.resume()
        }
    }
    func getAllNurseCalls(nurseId: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: getAllNurseCallsURL) {
            let queryString = "nurseId=\(nurseId)&key=\(md5Key)"
            self.getAllNurseCallTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.getAllNurseCallTask.resume()
        }
    }
    func updateCallStatus(nurseId: String,callId : String, statusId: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: updateCallStatusURL) {
            let queryString = "nurseId=\(nurseId)&callId=\(callId)&statusId=\(statusId)&key=\(md5Key)"
            self.updateCallStatusTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.updateCallStatusTask.resume()
        }
    }
    func sendNurseStatus(nurseId: String,statusId : String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendNurseStatusURL) {
            let queryString = "nurseId=\(nurseId)&statusId=\(statusId)&key=\(md5Key)"
            self.sendNurseStatusTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendNurseStatusTask.resume()
        }
    }
    func sendRemoveBooking(bookingId: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendRemoveBookingURL) {
            let queryString = "bookingId=\(bookingId)&key=\(md5Key)"
            self.sendRemoveBookingTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendRemoveBookingTask.resume()
        }
    }
    func sendReportNurse(bookingId: String,caseId: String,msg : String,dateReport: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendReporseNurseURL) {
            let queryString = "bookingId=\(bookingId)&key=\(md5Key)&caseId=\(caseId)&message=\(msg)&dateReport=\(dateReport)"
            self.sendReportNurseTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendReportNurseTask.resume()
        }
    }
    func bookingAskRefund(bookingId: String,refundType: String,refundMsg : String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendAskRefundURL) {
            let queryString = "bookingId=\(bookingId)&key=\(md5Key)&refundType=\(refundType)&refundMessage=\(refundMsg)"
            self.sendAskRefundTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendAskRefundTask.resume()
        }
    }
    func bookingSendMessage(userId: String,nurseId: String,msgDescription : String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: sendMessageURL) {
            let queryString = "nurseId=\(nurseId)&key=\(md5Key)&userId=\(userId)&messageDescription=\(msgDescription)"
            self.sendMessagingTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send message to nurse.")
                }
            });
            self.sendMessagingTask.resume()
        }
    }
    func cancelBooking(bookingId: String,cancelId: String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: cancelBookingURL) {
            let queryString = "bookingId=\(bookingId)&key=\(md5Key)&canceledId=\(cancelId)"
            self.cancelBookingTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to cancel requested booking.")
                }
            });
            self.cancelBookingTask.resume()
        }
    }
    func bookingApplyAgain(bookingId: String,bookingDate: String,bookingTime : String, transCode : String, transType : String, closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: applyAgainURL) {
            let queryString = "bookingId=\(bookingId)&key=\(md5Key)&bookingDate=\(bookingDate)&bookingTime=\(bookingTime)&transactionCode=\(transCode)&transactionType=\(transCode)"
            self.applyAgainTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to apply again.")
                }
            });
            self.applyAgainTask.resume()
        }
    }
    func forgotpassword(email: String, completionHandler closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: forgotpasswordURL) {
            let queryString = "email=\(email)&key=\(md5Key)"
            self.forgotPasswordTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "OK" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send forgot password request.")
                }
            });
            self.forgotPasswordTask.resume()
        }
    }
    func updateUserPassword(userId: String, userName: String, newPassword: String, newPasswordConfirm: String, actualPassword: String, completionHandler closure: (success : Bool, message : String?) -> Void){
        if let url = NSURL(string: updateUserPasswordURL) {
            let queryString = "userId=\(userId)&key=\(md5Key)&userName=\(userName)&newPassword=\(generateMD5(newPassword))&newPasswordConfirm=\(generateMD5(newPasswordConfirm))&actualPassword=\(generateMD5(actualPassword))"
            self.updateUserPasswordTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root) in
                var success = false
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    closure(success: success, message: "")
                } else {
                    closure(success: success, message: "AM failed to send update password request.")
                }
            });
            self.updateUserPasswordTask.resume()
        }
    }
    func logIn(email: String, pwd : String, completionHandler closure: (success : Bool, message: String?) -> Void) {
        
        if let url = NSURL(string: logInURL) {
            let md5pwd = generateMD5(pwd)
            let queryString = "email=\(email)&pwd=\(md5pwd)&key=\(md5Key)"
            self.logInTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var user : User?
                var message : String?
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let dicts = root["userInfo"] as! NSArray
                    let dict = dicts.firstObject as! NSDictionary
                    user = self.getUserWithDictionary(dict)
                    Singleton.sharedInstance.user = user
                } else {
                    message = "AM failed to login."
                }
                closure(success: success, message: message)
                
            });
            self.logInTask.resume()
        } else {
            closure(success: false, message: failedURLMessage)
        }
    }
    func register(email: String, pwd : String, completionHandler closure: (success : Bool, message: String?) -> Void) {
        if let url = NSURL(string: registerURL) {
            let md5Pwd = self.generateMD5(pwd)
            let queryString = "email=\(email)&pwd=\(md5Pwd)&key=\(md5Key)"
            self.registerTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var user : User?
                var message : String?
                if let status = root["status"] as? String where status == "OK" {
                    success = true
                    let dict = root["userInfo"] as! NSDictionary
                    user = self.getUserWithDictionary(dict)
                    Singleton.sharedInstance.user = user
                } else {
                    message = "AM failed to register."
                }
                closure(success: success, message: message)
                
            });
            self.registerTask.resume()
        } else {
            closure(success: false, message: failedURLMessage)
        }
    }
    func updateUserInfo(userID: String, email : String, fname : String, sname : String, mobilenum : String, address : String, city : String, zip : String, state : String, country : String, gender : String, date_of_birth : String, imageUpdate: Bool, image: UIImage, completionHandler closure: (success : Bool, message: String?) -> Void) {
        if let url = NSURL(string: updateUserInfoURL) {
            var queryString = "key=\(md5Key)&userId=\(userID)&email=\(email)&fname=\(fname)&sname=\(sname)&mobilenum=\(mobilenum)&address=\(address)&city=\(city)&zip=\(zip)&state=\(state)&country=\(country)&gender=\(gender)&date_of_birth=\(date_of_birth)"
            if imageUpdate == true {
                let str64: String = Functions.getImageData(image)
                queryString += "&imgUpdate=YES&imgName=imgProfile&imgExt=JPG"
                queryString += "&imgBase64=\(str64)"
            }else{
                queryString += "&imgUpdate=NO"
            }
            self.updateUserInfoTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    if imageUpdate == true {
                        if let imgURL = root["imgUrl"] as? String {
                            Singleton.sharedInstance.user.imgURL = imgURL
                        }
                    }
                }
                message = root["message"] as? String
                closure(success: success, message: message)
                
            });
            self.updateUserInfoTask.resume()
        } else {
            closure(success: false, message: failedURLMessage)
        }
    }
    func getServiceCategory(completionHandler closure: (success : Bool,category : [ServiceCategory],  message: String?) -> Void) {
        if let url = NSURL(string: getCategoryURL) {
            let queryString = "key=\(md5Key)"
            self.getCategoryTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                var category = [ServiceCategory]()
                if let status = root["status"] as? String where status == "OK" {
                    success = true
                    let dict = root["categories"] as! NSArray
                    category = self.getCategoryWithDictionary(dict)
                    
                } else {
                    message = "AM failed to register."
                }
                closure(success: success,category: category, message: message)
                
            });
            self.getCategoryTask.resume()
        } else {
            closure(success: false,category: [], message: failedURLMessage)
        }
    }
    func sendBookingRequest(type : String,isGPS : Bool, lat: Double, long: Double, address: String, clinicId: String, timeType: Bool, date: NSDate, serviceId: String,userId: String, transactionType: Bool, transactionCode: String, amount: String,  completionHandler closure: (success : Bool,  message: String?) -> Void) {
        if let url = NSURL(string: sendBookingRequestURL) {
            var queryString = ""
            var trans_type : Int
            var time_type : Int
            if timeType == true {
                time_type = 1
            } else {
                time_type = 0
            }
            if transactionType == true {
                trans_type = 1
            } else {
                trans_type = 0
            }
            if type == "clinic" && isGPS == true {
                let bookingDate = self.getDateFormat(date)
                let bookingTime = self.getTimeFormat(date)
                queryString = "key=\(md5Key)&bookingType=\(type)&gps=1&gpsLatitud=\(lat)&gpsLongitud=\(long)&clinicId=\(clinicId)&timeType=\(time_type)&bookingDate=\(bookingDate)&bookingTime=\(bookingTime)&serviceId=\(serviceId)&userId=\(userId)&transactionType=\(trans_type)&transactionCode=\(transactionCode)&amount=\(amount)"
                print("queryString = \(queryString)")
                
            } else if type == "clinic" && isGPS == false {
                let bookingDate = self.getDateFormat(date)
                let bookingTime = self.getTimeFormat(date)
                queryString = "key=\(md5Key)&bookingType=\(type)&gps=0&gpsLatitud=\(lat)&clientAddress=\(address)&timeType=\(time_type)&bookingDate=\(bookingDate)&bookingTime=\(bookingTime)&serviceId=\(serviceId)&userId=\(userId)&transactionType=\(trans_type)&transactionCode=\(transactionCode)&amount=\(amount)"
                print("queryString = \(queryString)")
            } else if type == "house" && isGPS == true {
                let bookingDate = self.getDateFormat(date)
                let bookingTime = self.getTimeFormat(date)
                queryString = "key=\(md5Key)&bookingType=\(type)&gps=1&gpsLatitud=\(lat)&gpsLongitud=\(long)&timeType=\(time_type)&bookingDate=\(bookingDate)&bookingTime=\(bookingTime)&serviceId=\(serviceId)&userId=\(userId)&transactionType=\(trans_type)&transactionCode=\(transactionCode)&amount=\(amount)"
                print("queryString = \(queryString)")
            } else {
                let bookingDate = self.getDateFormat(date)
                let bookingTime = self.getTimeFormat(date)
                queryString = "key=\(md5Key)&bookingType=\(type)&gps=0&clientAddress=\(address)&timeType=\(time_type)&bookingDate=\(bookingDate)&bookingTime=\(bookingTime)&serviceId=\(serviceId)&userId=\(userId)&transactionType=\(trans_type)&transactionCode=\(transactionCode)&amount=\(amount)"
                print("queryString = \(queryString)")
            }
            NSLog("log")
            self.sendBookingRequestTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    
                } else {
                    if let msg = root["message"] as? String {
                        message = msg
                    } else {
                        message = "AM failed to send booking request."
                    }
                }
                closure(success: success, message: message)
                
            });
            self.sendBookingRequestTask.resume()
        } else {
            closure(success: false, message: failedURLMessage)
        }
    }
    func getServiceItems(catId : String, completionHandler closure: (success : Bool,items : [ServiceItem],  message: String?) -> Void) {
        if let url = NSURL(string: getCategoryItemURL) {
            let queryString = "category_id=\(catId)&key=\(md5Key)"
            self.getServiceItemTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                var serviceItems = [ServiceItem]()
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let dict = root["categories"] as! NSArray
                    serviceItems = self.getServiceItems(dict)
                    
                } else {
                    message = "AM failed to register."
                }
                closure(success: success,items:serviceItems, message: message)
                
            });
            self.getServiceItemTask.resume()
        } else {
            closure(success: false,items: [], message: failedURLMessage)
        }
    }
    func getNurseItems(nurseId : String, completionHandler closure: (success : Bool,items : [Nurse],  message: String?) -> Void) {
        if let url = NSURL(string: getNurseURL) {
            var queryString = "key=\(md5Key)"
            if nurseId.characters.count > 0 {
                queryString += "&nurseId=\(nurseId)"
                print("Get Nurse Item Query = \(queryString)")
            }
            self.getNurseTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                var nurseItems = [Nurse]()
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let dict = root["nurses"] as! NSArray
                    nurseItems = self.getNurseItems(dict)
                    
                } else {
                    message = "AM failed to load items."
                }
                closure(success: success,items:nurseItems, message: message)
                
            });
            self.getNurseTask.resume()
        } else {
            closure(success: false,items: [], message: failedURLMessage)
        }
    }
    func getClinicItems(clinicId : String,  completionHandler closure: (success : Bool,items : [Clinic],  message: String?) -> Void) {
        if let url = NSURL(string: getClinicURL) {
            var queryString = ""
            if clinicId.characters.count > 0{
                queryString = "key=\(md5Key)&clinicId=\(clinicId)"
            } else {
                queryString = "key=\(md5Key)"
            }
            self.getClinicTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                var clinicItems = [Clinic]()
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let dict = root["clinics"] as! NSArray
                    clinicItems = self.getClinicItems(dict)
                    
                } else {
                    message = "AM failed to load items."
                }
                closure(success: success,items:clinicItems, message: message)
                
            });
            self.getClinicTask.resume()
        } else {
            closure(success: false,items: [], message: failedURLMessage)
        }
    }
    func getBookingItems(userId : String, bookingId : String,  completionHandler closure: (success : Bool,items : [Booking],  message: String?) -> Void) {
        if let url = NSURL(string: getBookingURL) {
            var queryString = "key=\(md5Key)"
            if userId.characters.count > 0{
                queryString += "&userId=\(userId)"
//                queryString += "&userId=1"
                print("Get Booking Items Query = \(queryString)")
            }
            if bookingId.characters.count > 0 {
                queryString += "&bookingId=\(bookingId)"
                print("Get Booking Items Query = \(queryString)")
            }
            NSLog("Log")
            self.getBookingTask = postDataInURL(url, queryString: queryString, setCookies: true, completionHandler: { (root: NSDictionary) -> Void in
                var success = false
                var message : String?
                var bookingItems = [Booking]()
                if let status = root["status"] as? String where status == "success" {
                    success = true
                    let dict = root["bookings"] as! NSArray
                    bookingItems = self.getBookingItems(dict)
                    print("Booking Items : \(bookingItems)")
                } else {
                    message = "AM failed to load items."
                }
                closure(success: success,items:bookingItems, message: message)
                
            });
            self.getBookingTask.resume()
        } else {
            closure(success: false,items: [], message: failedURLMessage)
        }
    }
    private func postDataInURL(url: NSURL, queryString: String, setCookies: Bool, completionHandler closure: ((root: NSDictionary) -> Void)?) -> NSURLSessionUploadTask {
        let session = NSURLSession.sharedSession();
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        print("[AM] posting data to: \(url), parameters: \(queryString)")
        let task = session.uploadTaskWithRequest(request, fromData: queryString.dataUsingEncoding(NSUTF8StringEncoding), completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var root = NSDictionary()
            if data != nil && data!.length > 0 {
                if let e = error {
                    print("[AM] error: \(e)")
                } else {
                    do {
                        let r = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! [NSObject: AnyObject]
                        self.postCookies(response!);
                        root = r as NSDictionary;
                    } catch let parseError {
                        let s = NSString(data: data!, encoding: NSUTF8StringEncoding);
                        print("[AM] - UNABLE TO PARSE JSON: \(s)");
                        print(parseError);
                    }
                    print("[AM] - ROOT \(root)");
                }
            } else {
                if(data != nil){
                    let s = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("[AM] Response: \(s)");
                }
                if let e = error {
                    print("[AM] failed to get main data back from POST. Error: \(e)")
                } else {
                    print("[AM] no data back from POST")
                }
            }
            session.finishTasksAndInvalidate()
            if let closure = closure {
                closure(root: root)
            }
        });
        return task;
    }
    private func getDataFromURL(url: NSURL, completionHandler closure: (root: NSDictionary) -> Void) {
        print("[AM] url: \(url)")
        let session = NSURLSession.sharedSession();
        let task = session.dataTaskWithURL(url, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var root = NSDictionary();
            if ( data != nil && data!.length > 0) {
                if let e = error {
                    print("[AM] error: \(e)")
                } else {
                    do {
                        let r = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as! [NSObject: AnyObject]
                        root = r as NSDictionary;
                    } catch let parseError {
                        let s = NSString(data: data!, encoding: NSUTF8StringEncoding);
                        print("[AM] - UNABLE TO PARSE JSON: \(s)");
                        print(parseError);
                    }
                }
            } else {
                if let e = error {
                    print("[AM] failed to get main data back. Error: \(e)")
                } else {
                    print("[AM] no data back")
                }
            }
            session.finishTasksAndInvalidate()
            closure(root: root)
        });
        task.resume()
    }
    private func postCookies(response: NSURLResponse) {
        if let httpResp = response as? NSHTTPURLResponse {
            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields((httpResp.allHeaderFields as? [String:String])!, forURL: response.URL!) as [NSHTTPCookie]
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response.URL!, mainDocumentURL: nil)
            for cookie in cookies {
                var cookieProps = [String: AnyObject]()
                cookieProps[NSHTTPCookieName] = cookie.name
                cookieProps[NSHTTPCookieValue] = cookie.value
                cookieProps[NSHTTPCookieDomain] = cookie.domain
                cookieProps[NSHTTPCookiePath] = cookie.path
                cookieProps[NSHTTPCookieVersion] = cookie.version
                cookieProps[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(63072000) // 2 years
                let newCookie = NSHTTPCookie(properties: cookieProps)
                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
                print("[AM] cookie name: \(cookie.name), value: \(cookie.value)")
            }
        }
    }
    func generateMD5(strKey : String) -> String {
        let key = strKey.md5()
        return key
    }
    func getCategoryWithDictionary(dicts : NSArray) -> [ServiceCategory] {
        var cat_arry = [ServiceCategory]()
        for i in 0 ..< dicts.count  {
            let dict = dicts[i] as! NSDictionary
            let cat = self.getServiceCategoryItem(dict)
            cat_arry.append(cat)
        }
        return cat_arry
        
    }
    func getServiceCategoryItem(dict : NSDictionary) -> ServiceCategory {
        var id = ""
        var name = ""
        var description = ""
        var imageurl = ""
        var housecall = false
        if let cat_id = dict.objectForKey("category_id") as? String {
            id = cat_id
        }
        if let cat_name = dict.objectForKey("category_name") as? String {
            name = cat_name
        }
        if let cat_description = dict.objectForKey("category_description") as? String {
            description = cat_description
        }
        if let cat_imageUrl = dict.objectForKey("cat_image_url") as? String {
            imageurl = cat_imageUrl
        }
        if let cat_housecall = dict.objectForKey("inhouse_call") as? Bool {
            housecall = cat_housecall
        }
        let cat = ServiceCategory(id: id, name: name, description: description, url: imageurl, call: housecall)
        return cat
    }
    func getNurseItem(dictItem : NSDictionary) -> Nurse {
        var id = ""
        var isOnline = false
        var isActive = false
        var longitude : Double = -118.000
        var latitude : Double = 34.000
        var date_location : NSDate?
        var img_url = ""
        var firstName = ""
        var lastName = ""
        var review  = ""
        var score : Double?
        var avServices = [NurseAvService]()
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let nurse_id = dictItem.objectForKey("nurse_id") as? String {
            id = nurse_id
        }
        if let online = dictItem.objectForKey("online") as? String where online == "1" {
            isOnline = true
        }
        if let active = dictItem.objectForKey("active") as? String where active == "1" {
            isActive = true
        }
        if let last_longitud = dictItem.objectForKey("last_longitud") as? String {
            longitude = Double(last_longitud)!
        }
        if let last_latitud = dictItem.objectForKey("last_latitud") as? String {
            latitude = Double(last_latitud)!
        }
        if let last_date_location = dictItem.objectForKey("last_date_location") as? String {
            let date = dateFormater.dateFromString(last_date_location)
            date_location = date!
        }
        if let url = dictItem.objectForKey("img_url") as? String {
            img_url = url
        }
        if let fName = dictItem.objectForKey("fname") as? String {
            firstName = fName
        }
        if let lName = dictItem.objectForKey("sname") as? String {
            lastName = lName
        }
        if let strReview = dictItem.objectForKey("review_average") as? String {
            print("String Score : \(strReview)")
            let servScore = Double(strReview)
            print("Double Score : \(servScore)")
            score = servScore
        }
        if let strCompleted = dictItem.objectForKey("services_completed") as? String {
            review = strCompleted
        }
        if let _avServices = dictItem.objectForKey("services") as? NSArray {
            avServices = self.getNurseAVServices(_avServices)
        }
        let nurseItem = Nurse(id: id, online: isOnline, active: isActive, long: longitude, lat: latitude, date: date_location!, url: img_url, firstName: firstName, lastName: lastName, review: review, score: score!,servs: avServices)
        return nurseItem
    }
    func getNurseAVServices(dicts : NSArray) -> [NurseAvService] {
        var avservices = [NurseAvService]()
        for i in 0 ..< dicts.count {
            let dictItem = dicts[i] as! NSDictionary
            let item = self.getNurseAVService(dictItem)
            avservices.append(item)
        }
        return avservices
    }
    func getNurseAVService(dictItem : NSDictionary) -> NurseAvService {
        var id = ""
        var nurseId = ""
        var servId = ""
        var isAvailable = false
        var approvedId = ""
        
        if let _id = dictItem.objectForKey("nurse_service_id") as? String {
            id = _id
        }
        if let _nurseId = dictItem.objectForKey("nurse_id") as? String {
            nurseId = _nurseId
        }
        if let _servId = dictItem.objectForKey("service_id") as? String {
            servId = _servId
        }
        if let _available = dictItem.objectForKey("available") as? String {
            if _available == "1" {
                isAvailable = true
            }
        }
        if let _approved_by = dictItem.objectForKey("approved_by") as? String {
            approvedId = _approved_by
        }
        let item = NurseAvService(_id: id, _nurseId: nurseId, _servId: servId, _isAvailable: isAvailable, _approvedById: approvedId)
        return item
    }
    func getNurseItems(dicts : NSArray) -> [Nurse] {
        var nurse_array = [Nurse]()
        for i in 0 ..< dicts.count {
            let dictItem = dicts[i] as! NSDictionary
            let nurseItem = self.getNurseItem(dictItem)
            nurse_array.append(nurseItem)
            
        }
        return nurse_array
    }
    func getClinicITem(dictItem : NSDictionary) -> Clinic {
        var id = ""
        var name = ""
        var address = ""
        var zipcode = ""
        var city = ""
        var state = ""
        var managerId = ""
        var latitude = ""
        var longitude = ""
        if let clinicId = dictItem.objectForKey("clinic_id") as? String {
            id = clinicId
        }
        if let clinic_name = dictItem.objectForKey("clinic_name") as? String {
            name = clinic_name
        }
        if let clinic_address = dictItem.objectForKey("clinic_address") as? String {
            address = clinic_address
        }
        if let clinic_zipcode = dictItem.objectForKey("clinic_zipcode") as? String {
            zipcode = clinic_zipcode
        }
        if let clinic_city = dictItem.objectForKey("clinic_city") as? String {
            city = clinic_city
        }
        if let clinic_state = dictItem.objectForKey("clinic_state") as? String {
            state = clinic_state
        }
        if let clinic_manager_id = dictItem.objectForKey("clinic_manager_id") as? String {
            managerId = clinic_manager_id
        }
        if let clinic_latitud = dictItem.objectForKey("clinic_latitud") as? String {
            latitude = clinic_latitud
        }
        if let clinic_longitud = dictItem.objectForKey("clinic_longitud") as? String {
            longitude = clinic_longitud
        }
        let item = Clinic(id: id, name: name, address: address, zipCode: zipcode, city: city, state: state, managerId: managerId, lat: latitude, long: longitude)
        return item
    }
    func getClinicItems(dicts : NSArray) -> [Clinic] {
        var clinic_arry = [Clinic]()
        for i in 0 ..< dicts.count {
            let dictItem = dicts[i] as! NSDictionary
            let item = self.getClinicITem(dictItem)
            clinic_arry.append(item)
        }
        return clinic_arry
    }
    func getServiceItem(dict : NSDictionary) -> ServiceItem {
        var servId = ""
        var name = ""
        var catId = ""
        var serv_des = ""
        var servprice : String?
        var servImg = ""
        var mobDes = ""
        var inHouseCall = false
        var servdiscount : String?
        var deliveryFee : String?
        if let serv_id = dict.objectForKey("service_id") as? String {
            servId = serv_id
        }
        if let service_name = dict.objectForKey("service_name") as? String {
            name = service_name
        }
        if let category_id = dict.objectForKey("category_id") as? String {
            catId = category_id
        }
        if let service_description = dict.objectForKey("service_description") as? String {
            serv_des = service_description
        }
        if let price = dict.objectForKey("price") as? String {
            servprice = price
        }
        if let service_img = dict.objectForKey("service_img") as? String {
            servImg = service_img
        }
        if let mobile_description = dict.objectForKey("mobile_description") as? String {
            mobDes = mobile_description
        }
        if let str_inhouse_call = dict.objectForKey("inhouse_call") as? String {
            if str_inhouse_call == "1" {
                inHouseCall = true
            }
        }
        if let discount = dict.objectForKey("discount") as? String {
            servdiscount = discount
        }
        if let delivery_fee = dict.objectForKey("delivery_fee") as? String {
            deliveryFee = delivery_fee
        }
        let serv = ServiceItem(servId: servId, name: name, catId: catId, servDes: serv_des, price: servprice!, inHouseCall: inHouseCall, imgUrl: servImg, mobDes: mobDes, discount: servdiscount!, fee: deliveryFee!)
        return serv
    }
    func getServiceItems(dicts : NSArray) -> [ServiceItem] {
        var serv_arry = [ServiceItem]()
        for i in 0 ..< dicts.count {
            let dict = dicts[i] as! NSDictionary
            let serv = self.getServiceItem(dict)
            serv_arry.append(serv)
        }
        return serv_arry
    }
    func getBookingItem(dict : NSDictionary) ->Booking {
        var bookingId = ""
        var bookingType = false
        var userId = ""
        var isGPS = false
        var lattitude : Double = 0.0
        var longitude : Double = 0.0
        var address = ""
        var clinicId = ""
        var timeType = false
        var booking_date = ""
        var booking_time = ""
        var servId = ""
        var transcode = ""
        var transtype = ""
        var processId = 0
        var status = 0
        var canceltype = 0
        var isNurseAssigned = false
        var reviewRating = ""
        var createdDate = NSDate()
        var nurseId = ""
        var _nurseInfo : Nurse!
        var _clinicInfo : Clinic!
        var _servInfo : ServiceCategory!
        var _prodInfo : ServiceItem!
        var _isemptyProd = false
        var _isemptyServ = false
        
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let createdDateFormater = NSDateFormatter()
        createdDateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let booking_id = dict.objectForKey("booking_id") as? String {
            bookingId = booking_id
        }
        if let userid = dict.objectForKey("userid") as? String {
            userId = userid
        }
        if let booking_type = dict.objectForKey("booking_type") as? String {
            if booking_type == "clinic" {
                bookingType = true
            }
        }
        if let gps_latitud = dict.objectForKey("gps_latitud") as? String {
            lattitude = Double(gps_latitud)!
        }
        if let gps = dict.objectForKey("gps") as? String {
            if gps == "1" {
                isGPS = true
            }
        }
        if let gps_longitud = dict.objectForKey("gps_longitud") as? String {
            longitude = Double(gps_longitud)!
        }
        if let client_address = dict.objectForKey("client_address") as? String {
            address = client_address
        }
        if let clinic_id = dict.objectForKey("clinic_id") as? String {
            clinicId = clinic_id
        }
        if let time_Type = dict.objectForKey("time_type") as? String {
            if time_Type == "1" {
                timeType = true
            }
        }
        if let bookingdate = dict.objectForKey("booking_date") as? String {
            booking_date = bookingdate
        }
        if let bookingtime = dict.objectForKey("booking_time") as? String {
            booking_time = bookingtime
        }
        if let service_id = dict.objectForKey("service_id") as? String {
            servId = service_id
        }
        if let transaction_code = dict.objectForKey("transaction_code") as? String {
            transcode = transaction_code
        }
        if let transaction_type = dict.objectForKey("transaction_type") as? String {
            transtype = transaction_type
        }
        if let process_id = dict.objectForKey("process_id") as? String {
            processId = Int(process_id)!
        }
        if let _status = dict.objectForKey("status") as? String {
            status = Int(_status)!
        }
        if let _canceltype = dict.objectForKey("canceled") as? String {
            canceltype = Int(_canceltype)!
        }
        if let nurse_id_assigned = dict.objectForKey("nurse_id_assigned") as? String {
            if nurse_id_assigned == "1" {
                isNurseAssigned = true
            }
        }
        if let review_rate = dict.objectForKey("review_rate") as? String {
            reviewRating = review_rate
        }
        if let _createdDate = dict.objectForKey("created") as? String {
            if _createdDate != "0000-00-00 00:00:00" && _createdDate.characters.count > 0{
                createdDate = createdDateFormater.dateFromString(_createdDate)!
            }
            
        }
        if let process_id = dict.objectForKey("nurseId") as? String {
            processId = Int(process_id)!
        }
        if let nurseInfo = dict.objectForKey("nurseInfo") as? NSDictionary {
            if let _nurseId = nurseInfo.objectForKey("nurse_id") as? String {
                nurseId = _nurseId
            }
            _nurseInfo = self.getNurseItem(nurseInfo)
        } else {
            _nurseInfo = Nurse(id: "", online: false, active: false, long: 0, lat: 0, date: NSDate(), url: "", firstName: "", lastName: "", review: "", score: 0, servs: [])
        }
        if let clinicInfo = dict.objectForKey("clinicInfo") as? NSDictionary {
            _clinicInfo = self.getClinicITem(clinicInfo)
        } else {
            _clinicInfo = Clinic(id: "", name: "", address: "", zipCode: "", city: "", state: "", managerId: "", lat: "", long: "")
        }
        if let prodInfo = dict.objectForKey("service_id") as? NSDictionary {
            _isemptyProd = true
            _prodInfo = self.getServiceItem(prodInfo)
            if let servInfo = prodInfo.objectForKey("category_id") as? NSDictionary {
                _isemptyServ = true
                _servInfo = self.getServiceCategoryItem(servInfo)
            } else {
                _isemptyServ = false
                _servInfo = ServiceCategory(id: "", name: "", description: "", url: "", call: false)
            }
        
        } else {
            _isemptyServ = false
            _isemptyProd = false
            _prodInfo = ServiceItem(servId: "", name: "", catId: "", servDes: "", price: "", inHouseCall: false, imgUrl: "", mobDes: "", discount: "", fee: "")
        }
        
        let bookingItem = Booking(bookingId: bookingId, userId: userId, isGPS: isGPS, bookingType: bookingType, latitude: lattitude, longitude: longitude, address: address, cliendId: clinicId, timeType: timeType, booking_date: booking_date, booking_time: booking_time, servId: servId, transCode: transcode, transType: transtype, proc_id: processId, status: status, cancel: canceltype, isNurseAssigned: isNurseAssigned, reviewRate: reviewRating, createdDate: createdDate, nurseId: nurseId, _clinicInfo: _clinicInfo, _nurseInfo: _nurseInfo, _servCategory: _servInfo, _prodInfo: _prodInfo, _isemptyProd: _isemptyProd, _isemptyServ: _isemptyServ)
        return bookingItem
    }
    func getBookingItems(dicts : NSArray) -> [Booking]{
        var book_arry = [Booking]()
        for i in 0 ..< dicts.count {
            let dict = dicts[i] as! NSDictionary
            let bookingItem = self.getBookingItem(dict)
            book_arry.append(bookingItem)
        }
        return book_arry
    }
    func getUserWithDictionary(dictUser : NSDictionary) -> User {
        
        var user : User?
        if let email = dictUser.objectForKey("email") as? String {
            user = User(email: email)
        } else {
            user = User(email: "")
        }
        if let id = dictUser.objectForKey("userid") as? String {
            user!.id = id
        } else {
            user!.id = ""
        }
        if let firstName = dictUser.objectForKey("fname") as? String {
            user!.firstName = firstName
        } else {
            user!.firstName = ""
        }
        if let lastName = dictUser.objectForKey("sname") as? String {
            user!.lastName = lastName
        } else {
            user!.lastName = ""
        }
        if let zipCode = dictUser.objectForKey("zip") as? String {
            user!.zipCode = zipCode
        } else {
            user!.zipCode = ""
        }
        if let state = dictUser.objectForKey("state") as? String {
            user!.state = state
        } else {
            user!.zipCode = ""
        }
        if let phoneNumber = dictUser.objectForKey("mobilenum") as? String {
            user!.phoneNumber = phoneNumber
        } else {
            user!.phoneNumber = ""
        }
        if let country = dictUser.objectForKey("country") as? String {
            user!.country = country
        } else {
            user!.country = ""
        }
        if let city = dictUser.objectForKey("city") as? String {
            user!.city = city
        } else {
            user!.city = ""
        }
        if let address = dictUser.objectForKey("address") as? String {
            user!.address = address
        } else {
            user!.address = ""
        }
        if let gender = dictUser.objectForKey("gender") as? String {
            user!.gender = gender
        } else {
            user!.gender = ""
        }
        if let status_flag = dictUser.objectForKey("status_flag") as? Int {
            user!.status_flag = status_flag
        } else {
            user!.status_flag = 3
        }
        if let active_flag = dictUser.objectForKey("gender") as? Bool {
            user!.active_flag = active_flag
        } else {
            user!.active_flag = false
        }
        if let userGroup = dictUser.objectForKey("usergroup") as? Int {
            user!.userGroup = userGroup
        } else {
            user!.userGroup = 4
        }
        if let message = dictUser.objectForKey("message") as? String {
            user!.message = message
        } else {
            user!.message = "Something went wrong."
        }
        if let date_of_birth = dictUser.objectForKey("date_of_birth") as? String {
            let date = Functions.getDateFromString(date_of_birth)
            user!.birthDate = date
            let year_birth = getYear(date)
            let current_date = NSDate()
            let current_year = getYear(current_date)
            user!.age = current_year! - year_birth!
        }
        if let imgURL = dictUser.objectForKey("img_url") as? String {
            user!.imgURL = imgURL
            if let url = NSURL(string: imgURL), data = NSData(contentsOfURL: url){
                user!.profileImage = UIImage(data: data)
            }
        }else {
            user!.imgURL = ""
        }
        return user!
        
    }
    func getYear(date : NSDate) -> Int? {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.component(.Year, fromDate: date)
        return components
    }
    func getDateFormat(date : NSDate) -> String {
        var stringDate = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        stringDate = dateFormatter.stringFromDate(date)
        return stringDate
    }
    func getTimeFormat(date : NSDate) -> String {
        var stringTime = ""
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute,.Second], fromDate: date)
        let hour = comp.hour
        let minute = comp.minute
        let second = comp.second
        stringTime = String(format: "%d:%d:%d", hour, minute,second)
        return stringTime
    }
}
