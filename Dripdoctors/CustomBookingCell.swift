//
//  CustomBookingCell.swift
//  Dripdoctors
//
//  Created by mac on 8/21/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class CustomBookingCell: UIView {
    var imgBGCell: UIImageView!
    var imgServLogo: UIImageView!
    var lblServName: UILabel!
    var lblProdInfo: UILabel!
    var lblBookingStatus: UILabel!
    var lblAddress: UILabel!
    var lblCallType: UILabel!
    var lblbookingDate: UILabel!
    var vwNurse: UIView!
    var imgNursePhoto: UIImageView!
    var vwEditing: UIView!
    var btnOption : UIButton!
    var vwNurseName : UIView!
    var lblNurseName : UILabel!
    var btnEdit : UIButton!
    var btnSendMessage : UIButton!
    var btnCancelBooking : UIButton!
    
    var index : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let frameSize = frame.size
        let bgImgRect = CGRectMake(0, 0, frameSize.width, frameSize.height - 2)
        let imgServLogoRect = CGRectMake(10, 5, 65, 60)
        let lblStatusRect = CGRectMake(frameSize.width - 145, 15, 136, 20)
        let lblServNameRect = CGRectMake(78, 10, frameSize.width - 220, 25)
        let lblProdRect = CGRectMake(78, 32, frameSize.width - 220, 25)
        let lblAddressRect = CGRectMake(10, 125, frameSize.width - 160, 25)
        let lblCallTypeRect = CGRectMake(10, 110, frameSize.width - 160, 25)
        let lblBookingDateRect = CGRectMake(10, 90, frameSize.width - 160, 25)
        let btnOptionsRect = CGRectMake(10, frameSize.height - 35, 80, 22)
        let vwNurseRect = CGRectMake(frameSize.width - 137, 38, frameSize.height - 40, 120)
        let imgNursePhotoRect = CGRectMake(0, 0, 120, 120)
        let vwNurseNameRect = CGRectMake(0, 120, 120, 40)
        let lblNurseNameRect = CGRectMake(0, 0, 120, 40)
        
        let vwEditingRect = CGRectMake(0, frameSize.height - 130, frameSize.width, 128)
        let vwEditingSize = vwEditingRect.size
        let btnEditRect = CGRectMake(16, (vwEditingSize.height - 40) / 2, vwEditingSize.width / 2 - 32, 40)
        let btnSendMessageRect = CGRectMake(vwEditingSize.width / 2 + 16, (vwEditingSize.height / 2 - 40) / 2, vwEditingSize.width / 2 - 32, 40)
        let btnCancelRect = CGRectMake(vwEditingSize.width / 2 + 16, (vwEditingSize.height / 2 - 40) / 2 + vwEditingSize.height / 2, vwEditingSize.width / 2 - 32, 40)
        
        imgBGCell = UIImageView(frame: bgImgRect)
        imgBGCell.backgroundColor = UIColor.whiteColor()
        
        imgServLogo = UIImageView(frame: imgServLogoRect)
        
        lblServName = UILabel(frame:lblServNameRect)
//        lblServName.font = UIFont.systemFontOfSize(13)
        lblServName.font = UIFont(name: "GoldenSans-Light", size: 15)
        lblServName.textColor = UIManager.sharedManager.selected_color

        lblProdInfo = UILabel(frame: lblProdRect)
//        lblProdInfo.font = UIFont.systemFontOfSize(13)
        lblProdInfo.font = UIFont(name: "Gilroy-ExtraBold", size: 16)
//        lblProdInfo.textColor = UIManager.sharedManager.normal_color
        lblProdInfo.textColor = UIColor.blackColor()
        
        lblBookingStatus = UILabel(frame: lblStatusRect)
//        lblBookingStatus.font = UIFont.systemFontOfSize(12)
        lblBookingStatus.font = UIFont(name: "GoldenSans-Light", size: 14)
        lblBookingStatus.textColor = UIColor.darkGrayColor()
        lblBookingStatus.textAlignment = .Center
        
        lblAddress = UILabel(frame: lblAddressRect)
//        lblAddress.font = UIFont.systemFontOfSize(11)
        lblAddress.font = UIFont(name: "GoldenSans-Light", size: 14)
//        lblAddress.textColor = UIManager.sharedManager.normal_color
        lblAddress.textColor = UIColor.blackColor()
        
        lblCallType = UILabel(frame: lblCallTypeRect)
//        lblCallType.textColor = UIManager.sharedManager.normal_color
        lblCallType.textColor = UIColor.blackColor()
//        lblCallType.font = UIFont.systemFontOfSize(11)
        lblCallType.font = UIFont(name: "GothamPro-Medium", size: 15)
        
        lblbookingDate = UILabel(frame: lblBookingDateRect)
//        lblbookingDate.font = UIFont.systemFontOfSize(11)
        lblbookingDate.font = UIFont(name: "GoldenSans-Light", size: 14)
        lblbookingDate.textColor = UIManager.sharedManager.normal_color
        lblbookingDate.textColor = UIColor.blackColor()
        
        btnOption = UIButton(frame: btnOptionsRect)
        btnOption.setBackgroundImage(UIImage(named: "option_button"), forState: .Normal)
//        btnOption.addTarget(self, action: #selector(CustomBookingCell.showVwEditing(_:)), forControlEvents: .TouchUpInside)
        
        vwNurse = UIView(frame: vwNurseRect)
        imgNursePhoto = UIImageView(frame: imgNursePhotoRect)
        imgNursePhoto.layer.borderColor = UIManager.sharedManager.selected_color.CGColor
        imgNursePhoto.layer.borderWidth = 1
        
        vwNurseName = UIView(frame: vwNurseNameRect)
        vwNurseName.backgroundColor = UIManager.sharedManager.selected_color
        lblNurseName = UILabel(frame: lblNurseNameRect)
//        lblNurseName.font = UIFont.systemFontOfSize(12)
        lblNurseName.font = UIFont(name: "GoldenSans-Light", size: 13)
        lblNurseName.textColor = UIColor.whiteColor()
        lblNurseName.textAlignment = .Center
        vwNurseName.addSubview(lblNurseName)
        vwNurse.addSubview(vwNurseName)
        vwNurse.addSubview(imgNursePhoto)
        
        vwEditing = UIView(frame: vwEditingRect)
        vwEditing.backgroundColor = UIManager.sharedManager.editbar_color
        
        btnEdit = UIButton(frame: btnEditRect)
//        btnEdit.backgroundColor = UIManager.sharedManager.normal_color
        btnEdit.setBackgroundImage(UIImage(named: "bookbutton"), forState: .Normal)
//        btnEdit.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnEdit.titleLabel?.font = UIFont(name: "GoldenSans-Light", size: 17)
        btnEdit.setTitle("Edit Booking", forState: .Normal)
        btnEdit.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
//        btnEdit.titleLabel?.text = "Edit Booking"
//        btnEdit.addTarget(self, action: #selector(CustomBookingCell.showEditBooking(_:)), forControlEvents: .TouchUpInside)
        
        btnSendMessage = UIButton(frame: btnSendMessageRect)
        btnSendMessage.setBackgroundImage(UIImage(named: "edit_button"), forState: .Normal)
        btnSendMessage.titleLabel?.textColor = UIColor.whiteColor()
//        btnSendMessage.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnSendMessage.titleLabel?.font = UIFont(name: "GoldenSans-Light", size: 17)
        btnSendMessage.setTitle("Send Message", forState: .Normal)
//        btnSendMessage.titleLabel?.text = "Send Message"
//        btnSendMessage.addTarget(self, action: #selector(CustomBookingCell.sendMessaging(_:)), forControlEvents: .TouchUpInside)
        
        btnCancelBooking = UIButton(frame: btnCancelRect)
        btnCancelBooking.setBackgroundImage(UIImage(named: "edit_button"), forState: .Normal)
        btnCancelBooking.titleLabel?.textColor = UIColor.whiteColor()
//        btnCancelBooking.titleLabel?.font = UIFont.systemFontOfSize(18)
        btnCancelBooking.titleLabel?.font = UIFont(name: "GoldenSans-Light", size: 17)
        btnCancelBooking.setTitle("Cancel Booking", forState: .Normal)
//        btnCancelBooking.titleLabel?.text = "Cancel Booking"
//        btnCancelBooking.addTarget(self, action: #selector(CustomBookingCell.sendBookingCancel(_:)), forControlEvents: .TouchUpInside)
        
        vwEditing.addSubview(btnEdit)
        vwEditing.addSubview(btnSendMessage)
        vwEditing.addSubview(btnCancelBooking)
        vwEditing.alpha = 0
        
        self.addSubview(imgBGCell)
        self.addSubview(imgServLogo)
        self.addSubview(lblServName)
        self.addSubview(lblProdInfo)
        self.addSubview(lblBookingStatus)
        self.addSubview(lblAddress)
        self.addSubview(lblCallType)
        self.addSubview(lblbookingDate)
        self.addSubview(btnOption)
        self.addSubview(vwNurse)
        self.addSubview(vwEditing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViewTag(tag : Int) {
        self.index = tag
        self.btnSendMessage.tag = tag
        self.btnCancelBooking.tag = tag
        self.btnOption.tag = tag
    }
    func showEditBooking(sender : UIButton) {
        let tag = sender.tag
        NSNotificationCenter.defaultCenter().postNotificationName("ShowEditBookingView", object: tag)
    }
    func showVwEditing(){
        self.vwEditing.alpha = 0.8
    }
    func hideVwEditting() {
        self.vwEditing.alpha = 0
    }
    func sendMessaging(sender : UIButton) {
        let tag = sender.tag
        NSNotificationCenter.defaultCenter().postNotificationName("ShowChatView", object: tag)
    }
    func sendBookingCancel(sender : UIButton) {
        let tag = sender.tag
        NSNotificationCenter.defaultCenter().postNotificationName("ShowBookingCancelView", object: tag)
    }
}
